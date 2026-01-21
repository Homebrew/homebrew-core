class ClaudeSquad < Formula
  desc "Manage multiple AI agents like Claude Code, Aider and Codex in your terminal"
  homepage "https://smtg-ai.github.io/claude-squad/"
  url "https://github.com/smtg-ai/claude-squad/archive/refs/tags/v1.0.14.tar.gz"
  sha256 "19951f70917aef7fda3810b47e3e2dc3110fb04027ff5dbbe3f3c502999b9610"
  license "AGPL-3.0-only"
  head "https://github.com/smtg-ai/claude-squad.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f606b288872a5a8f339b9b8ef1115ba7c31c65ad6bef10dab79064c491008d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f606b288872a5a8f339b9b8ef1115ba7c31c65ad6bef10dab79064c491008d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f606b288872a5a8f339b9b8ef1115ba7c31c65ad6bef10dab79064c491008d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4125914a8f0352ed054fbd8f71571441254b425312bd7ef099205686936e7d1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5ddb361d0f9cb157da039b658ec4cab15750ce3a5a18b1b3d60a95e4c9fc0d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a07e72ba58d582321b8a502e817df5bf0b0a39faae4b316972163445b0ba82d8"
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
