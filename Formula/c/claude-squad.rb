class ClaudeSquad < Formula
  desc "Manage multiple AI agents like Claude Code, Aider and Codex in your terminal"
  homepage "https://smtg-ai.github.io/claude-squad/"
  url "https://github.com/smtg-ai/claude-squad/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "7786e393577a0e5c73bef4f1aec20129e933327d1de936d5606931565c49b671"
  license "AGPL-3.0-only"
  head "https://github.com/smtg-ai/claude-squad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "117aeb1a9602db47717df1b793dcc301e5d444e0d56119b76eccf288519b0440"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "117aeb1a9602db47717df1b793dcc301e5d444e0d56119b76eccf288519b0440"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "117aeb1a9602db47717df1b793dcc301e5d444e0d56119b76eccf288519b0440"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d03f2f4eb138086ee21b465c5e25e88bef020137a570e102daf8b363d306b43"
    sha256 cellar: :any_skip_relocation, ventura:       "7d03f2f4eb138086ee21b465c5e25e88bef020137a570e102daf8b363d306b43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f531f43ebc67b5bbaa10c33224f7cdcfffca9de8508d7ad8c0bbd6b3cec56da"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"claude-squad", "completion")
  end

  test do
    output = shell_output(bin/"claude-squad")
    assert_includes output, "claude-squad must be run from within a git repository"
  end
end
