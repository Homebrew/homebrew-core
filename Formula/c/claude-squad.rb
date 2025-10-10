class ClaudeSquad < Formula
  desc "Manage multiple AI agents like Claude Code, Aider and Codex in your terminal"
  homepage "https://smtg-ai.github.io/claude-squad/"
  url "https://github.com/smtg-ai/claude-squad/archive/refs/tags/v1.0.13.tar.gz"
  sha256 "f621646464912f19196e1bf9da928fb3230854917d0cdfa112db4229f9e18053"
  license "AGPL-3.0-only"
  head "https://github.com/smtg-ai/claude-squad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0b1bb8aa53f96586525577631be36fc7b2a9b04eb812cda3bbfdb1c706e6d7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cfac1e30a04b1c13f84169a26471b35e1dfa316235c3a20078304cfa840f9ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cfac1e30a04b1c13f84169a26471b35e1dfa316235c3a20078304cfa840f9ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1cfac1e30a04b1c13f84169a26471b35e1dfa316235c3a20078304cfa840f9ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc839785050b1cda8d2a5994c87b6424e9cbb6bf7e44956e781a6e3f27f45501"
    sha256 cellar: :any_skip_relocation, ventura:       "cc839785050b1cda8d2a5994c87b6424e9cbb6bf7e44956e781a6e3f27f45501"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df6a88d6bbda2a5bae08218ba787e5c274c0541f5589c613925ec9a65b87f25a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccdf7ad9252d0b8921928319a70fc9afcb63a1cc1a2b90f6e0255eda0e0b336b"
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
