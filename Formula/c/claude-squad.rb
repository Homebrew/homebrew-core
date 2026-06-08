class ClaudeSquad < Formula
  desc "Manage multiple AI agents like Claude Code, Aider and Codex in your terminal"
  homepage "https://smtg-ai.github.io/claude-squad/"
  url "https://github.com/smtg-ai/claude-squad/archive/refs/tags/v1.0.18.tar.gz"
  sha256 "3ef6ead7fb78fe73fc0a4f2d12d49c5c3224ea0fa9116681a21bd4bf63a58f57"
  license "AGPL-3.0-only"
  head "https://github.com/smtg-ai/claude-squad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25c3f4ee80cdccacb1a5837c46653f3b311632b6508803e3a28b5d4838a047e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25c3f4ee80cdccacb1a5837c46653f3b311632b6508803e3a28b5d4838a047e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25c3f4ee80cdccacb1a5837c46653f3b311632b6508803e3a28b5d4838a047e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5069c6d32b878f2690a39aa5b3e355069aa17abbfde660506058bb8efb8bc043"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5b4fcfc643be76e35e9b956cc42f7a8cf7fb6b8537a227fab8459eb98f5639d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3a2301269344e58efdfb4efe5dac50e843b24b55f184f0e84605cdce2c51487"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"claude-squad", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output(bin/"claude-squad")
    assert_includes output, "claude-squad must be run from within a git repository"
  end
end
