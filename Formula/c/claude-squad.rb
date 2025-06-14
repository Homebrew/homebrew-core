class ClaudeSquad < Formula
  desc "Manage multiple AI agents like Claude Code, Aider and Codex in your terminal"
  homepage "https://smtg-ai.github.io/claude-squad/"
  url "https://github.com/smtg-ai/claude-squad/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "ab5646523447aab20aeff50fd43cc884267c2885e6ab88646097d1f6dfd2c138"
  license "AGPL-3.0-only"
  head "https://github.com/smtg-ai/claude-squad.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48e8807b7069cc2d76610fa465202fdfdf31b40bc339358fbed88d4fcff39a7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48e8807b7069cc2d76610fa465202fdfdf31b40bc339358fbed88d4fcff39a7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48e8807b7069cc2d76610fa465202fdfdf31b40bc339358fbed88d4fcff39a7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "76bc17370d29c5687287a72cbfa4a90e2999cd5f8ddda9ae42e84718b646660d"
    sha256 cellar: :any_skip_relocation, ventura:       "76bc17370d29c5687287a72cbfa4a90e2999cd5f8ddda9ae42e84718b646660d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb5a9e2bc179d5d6927bb90363c375d8409534098ad2342586015e9ce2155b5d"
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
