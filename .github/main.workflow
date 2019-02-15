workflow "Push" {
  on = "push"
  resolves = ["Generate formulae.brew.sh"]
}

action "Generate formulae.brew.sh" {
  uses = "docker://linuxbrew/brew"
  runs = "bash"
  args = ["-c", "pwd; whoami; ls; ls .github; bash .github/main.workflow.sh"]
  secrets = ["GITHUB_TOKEN"]
}
