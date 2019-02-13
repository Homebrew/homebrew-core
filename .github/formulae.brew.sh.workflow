workflow "Push" {
  on = "push"
  resolves = ["Deploy formulae.brew.sh"]
}

action "Clone formulae.brew.sh" {
  uses = "docker://linuxbrew/brew"
  runs = "git"
  args = ["clone", "https://$GITHUB_TOKEN@github.com/Homebrew/formulae.brew.sh", "formulae.brew.sh"]
  secrets = ["GITHUB_TOKEN"]
}

action "Generate formula.json" {
  needs = "Clone formulae.brew.sh"
  uses = "docker://linuxbrew/brew"
  runs = "rake"
  secrets = ["GITHUB_TOKEN"]
}
