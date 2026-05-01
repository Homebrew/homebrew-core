class JiraCommands < Formula
  desc "Fast terminal client for Atlassian Jira"
  homepage "https://github.com/mulhamna/jira-commands"
  url "https://github.com/mulhamna/jira-commands/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "f32ca1a21c21294f465d4dbca9e41df897d8ab3225e5c52c08f603e05b5ef5b9"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/mulhamna/jira-commands.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--bin", "jirac", *std_cargo_args(path: "crates/jira")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jirac --version")
    output = shell_output("#{bin}/jirac tui --help")
    assert_match "Jira", output
  end
end
