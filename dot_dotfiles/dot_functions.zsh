# source a file if it exists
include () {
  [[ -f $1 ]] && source $1
}

# Nuke NPM Node Modules and reinstall
npm_nuke() {
  rm -rf node_modules && npm install;
}

# Perform brew maintenance
brew_yolo() {
  brew update && \
  brew outdated && \
  brew upgrade && \
  brew postgresql-upgrade-database || brew cleanup
}

# Determine size of a file or total size of a directory
file_size() {
  if du -b /dev/null > /dev/null 2>&1; then
    local arg=-sbh;
  else
    local arg=-sh;
  fi
  if [[ -n "$@" ]]; then
    du $arg -- "$@";
  else
    du $arg .[^.]* ./*;
  fi;
}

# Create a data URL from a file
dataurl() {
  local mimeType=$(file -b --mime-type "$1");
  if [[ $mimeType == text/* ]]; then
    mimeType="${mimeType};charset=utf-8";
  fi
  echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}

# https://effective-shell.com/part-2-core-skills/understanding-commands
restart-shell() { exec -l $SHELL }

# Download a web page and show info on what took time
httpDebug () { /usr/bin/curl $@ -o /dev/null -w "dns: %{time_namelookup} connect: %{time_connect} pretransfer: %{time_pretransfer} starttransfer: %{time_starttransfer} total: %{time_total}\n" ; }
