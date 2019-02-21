workflow "Push" {
  on = "push"
  resolves = ["Generate formulae.brew.sh"]
}

action "Generate formulae.brew.sh" {
  uses = "docker://linuxbrew/brew"
  runs = ".github/main.workflow.sh"
  secrets = ["ANALYTICS_JSON_KEY", "FORMULAE_DEPLOY_KEY"]
}
