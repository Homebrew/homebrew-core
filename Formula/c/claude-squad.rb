class ClaudeSquad < Formula
  desc "Manage multiple AI agents like Claude Code, Aider and Codex in your terminal"
  homepage "https://smtg-ai.github.io/claude-squad/"
  url "https://github.com/smtg-ai/claude-squad/archive/refs/tags/v1.0.19.tar.gz"
  sha256 "f6642aef94e222dd485480397118a1eb6ef4a4d7fffdd8fe75025f918ec4916f"
  license "AGPL-3.0-only"
  head "https://github.com/smtg-ai/claude-squad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b645081ee8548df4c990fa4d0925baec949da7d1230f545d60b205a2561dea2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b645081ee8548df4c990fa4d0925baec949da7d1230f545d60b205a2561dea2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b645081ee8548df4c990fa4d0925baec949da7d1230f545d60b205a2561dea2"
    sha256 cellar: :any_skip_relocation, sonoma:        "17674edf4e599c44c62d5b5e1333a9f8c3add2a0f13f2b6d2d345f4bcb1afaec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aac8f801c93baed41b3d4c638b72d3fe510e65d55c7a23233231e70b3a17f8e2"
    sha256 cellar: :any,                 x86_64_linux:  "2ce1d9cbeb4bc18d22a205dea7f49431d32147cec7bda4fb397b32ccaa533b5f"
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
