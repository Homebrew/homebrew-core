workflow "Push" {
  on = "push"
  resolves = ["Generate formulae.brew.sh"]
}

action "Generate formulae.brew.sh" {
  uses = "docker://linuxbrew/brew"
  runs = "bash"
  user = "root"
  args = ["sudo chown -R linuxbrew .; chmod +x .github/main.workflow.sh; .github/main.workflow.sh"]
  secrets = ["GITHUB_TOKEN"]
}
