workflow "Push" {
  on = "push"
  resolves = ["Generate formulae.brew.sh"]
}

action "Generate formulae.brew.sh" {
  uses = "docker://linuxbrew/brew"
  runs = ".github/main.workflow.sh"
  secrets = ["HOMEBREW_ANALYTICS_JSON", "HOMEBREW_FORMULAE_DEPLOY_KEY"]
}
