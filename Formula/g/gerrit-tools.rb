class GerritTools < Formula
  desc "Tools to ease Gerrit code review"
  homepage "https://github.com/indirect/gerrit-tools"
  url "https://github.com/indirect/gerrit-tools/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c3a84af2ddb0f17b7a384e5dbc797329fb94d2499a75b6d8f4c8ed06a4a482dd"
  license "Apache-2.0"
  head "https://github.com/indirect/gerrit-tools.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "352ba04205d7ed543a550c973dbc68d07df3cac43760c11d8ca9c702525703c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "352ba04205d7ed543a550c973dbc68d07df3cac43760c11d8ca9c702525703c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "352ba04205d7ed543a550c973dbc68d07df3cac43760c11d8ca9c702525703c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "057c07eb30c39242fe39be9b0b251432a6407ac7866b4410b458e638eab6324f"
    sha256 cellar: :any_skip_relocation, ventura:       "057c07eb30c39242fe39be9b0b251432a6407ac7866b4410b458e638eab6324f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "352ba04205d7ed543a550c973dbc68d07df3cac43760c11d8ca9c702525703c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "352ba04205d7ed543a550c973dbc68d07df3cac43760c11d8ca9c702525703c1"
  end

  conflicts_with "git-gerrit", because: "both install `gerrit-cherry-pick` binaries"
  conflicts_with "git-review", because: "both install `git-review` binaries"

  def install
    prefix.install "bin"
  end

  test do
    system "git", "init"
    system "git", "remote", "add", "origin", "https://example.com/foo.git"
    hook = (testpath/".git/hooks/commit-msg")
    touch hook
    hook.chmod 0744

    ENV["GERRIT"] = "example.com"

    system bin/"gerrit-setup"
    assert_equal "github\norigin\n", shell_output("git remote")
  end
end
