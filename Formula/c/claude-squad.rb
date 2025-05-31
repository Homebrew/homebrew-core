class ClaudeSquad < Formula
  desc "Manage multiple AI agents like Claude Code, Aider and Codex in your terminal"
  homepage "https://smtg-ai.github.io/claude-squad/"
  url "https://github.com/smtg-ai/claude-squad/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "d790acb3d3ad80fdcd73be1200b6548367fde4abf39168d3d85a772bad0e84f6"
  license "AGPL-3.0-only"
  head "https://github.com/smtg-ai/claude-squad.git", branch: "main"

  depends_on "go" => :build
  depends_on "gh"
  depends_on "tmux"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"claude-squad", "completion")
  end

  test do
    output = shell_output(bin/"claude-squad")
    assert_includes output, "claude-squad must be run from within a git repository"
  end
end
