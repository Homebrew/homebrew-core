workflow "formulae.brew.sh generation" {
  on = "push"
  resolves = ["Filters for GitHub Actions"]
}

action "Master" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Shell" {
  needs = "Master"
  uses = "actions/bin/sh@master"
  args = ["git clone --depth=1 https://github.com/Homebrew/brew "$HOMEBREW_REPOSITORY""]
}
