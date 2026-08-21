class ClaudeSquad < Formula
  desc "Manage multiple AI agents like Claude Code, Aider and Codex in your terminal"
  homepage "https://smtg-ai.github.io/claude-squad/"
  url "https://github.com/smtg-ai/claude-squad/archive/refs/tags/v1.0.20.tar.gz"
  sha256 "1926816df3b9c9bd0455761beeb6b55fdd5f15e4b5dc47d0eb4f5315e4cb28a7"
  license "AGPL-3.0-only"
  head "https://github.com/smtg-ai/claude-squad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37922f7be81e49e073fe85f21b62b73761faff988e3f9f9d2fae196021e02080"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37922f7be81e49e073fe85f21b62b73761faff988e3f9f9d2fae196021e02080"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37922f7be81e49e073fe85f21b62b73761faff988e3f9f9d2fae196021e02080"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f308f419e9668c535b34c859cddf1dac4b387d99113acc1c7660527ef27e9e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a01f8d511668dfbfdda8bef2f1668f3deb0e53c85177ad05fe86f50854b48a1"
    sha256 cellar: :any,                 x86_64_linux:  "70f148d75469becb2620681708c23b3d8bcfcfcc42782909edb3010a0e81ac6b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
    generate_completions_from_executable(bin/"claude-squad", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output(bin/"claude-squad")
    assert_includes output, "claude-squad must be run from within a git repository"
  end
end
