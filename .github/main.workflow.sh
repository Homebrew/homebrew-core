#!/bin/bash

set -e

# silence bundler complaining about being root
mkdir ~/.bundle
echo 'BUNDLE_SILENCE_ROOT_WARNING: "1"' > ~/.bundle/config

# configure git
git config --global user.name "BrewTestBot"
git config --global user.email "homebrew-test-bot@lists.sfconservancy.org"

# create stubs so build dependencies aren't incorrectly flagged as missing
for i in python svn unzip xz
do
  touch /usr/bin/$i
  chmod +x /usr/bin/$i
done

# tap Homebrew/homebrew-core instead of Linuxbrew's
rm -rf "$(brew --repo homebrew/core)"
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_FORCE_HOMEBREW_ON_LINUX=1
export PATH="$(brew --repo)/Library/Homebrew/vendor/portable-ruby/current/bin:$PATH"
brew tap homebrew/core

# configure SSH
mkdir ~/.ssh
echo "StrictHostKeyChecking no" > ~/.ssh/config
echo "$HOMEBREW_FORMULAE_DEPLOY_KEY" > ~/.ssh/id_ed25519

# clone formulae.brew.sh with SSH so we can push back
git clone git@github.com:Homebrew/formulae.brew.sh
cd formulae.brew.sh

# re-enable analytics to generate them
echo "$HOMEBREW_ANALYTICS_JSON" > ~/.homebrew_analytics.json
unset HOMEBREW_NO_ANALYTICS

# run rake (without a rake binary)
ruby -e "load Gem.bin_path('rake', 'rake')"

# commit and push generated files
git commit -m '_data: update from Homebrew/core push' _data/
git push https://$GITHUB_TOKEN@github.com/Homebrew/formulae.brew.sh
