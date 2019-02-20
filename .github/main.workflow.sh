#!/bin/bash

set -e

# take ownership as current user (in case it's linuxbrew)
sudo mkdir ~/.cache
sudo chown -R $USER . ~/.cache

# create stubs so build dependencies aren't incorrectly flagged as missing
for i in python svn unzip xz
do
  sudo touch /usr/bin/$i
  sudo chmod +x /usr/bin/$i
done

# tap Homebrew/homebrew-core instead of Linuxbrew's
rm -rf "$(brew --repo homebrew/core)"
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_FORCE_HOMEBREW_ON_LINUX=1
export BUNDLE_SILENCE_ROOT_WARNING=1
export PATH="$(brew --repo)/Library/Homebrew/vendor/portable-ruby/current/bin:$PATH"
brew tap homebrew/core

# clone formulae.brew.sh with token so we can push back
git clone https://$GITHUB_TOKEN@github.com/Homebrew/formulae.brew.sh

echo "$HOMEBREW_ANALYTICS_JSON" > ~/.homebrew_analytics.json

cd formulae.brew.sh

unset HOMEBREW_NO_ANALYTICS
rm _data/analytics/build-error/30d.json
# run rake (without a rake binary)
ruby -e "load Gem.bin_path('rake', 'rake')"
git diff --stat
