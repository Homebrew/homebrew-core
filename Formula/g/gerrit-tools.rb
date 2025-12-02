class GerritTools < Formula
  desc "Tools to ease Gerrit code review"
  homepage "https://github.com/indirect/gerrit-tools"
  url "https://github.com/indirect/gerrit-tools/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c3a84af2ddb0f17b7a384e5dbc797329fb94d2499a75b6d8f4c8ed06a4a482dd"
  license "Apache-2.0"
  head "https://github.com/indirect/gerrit-tools.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "5f4f0ba04b41b1b03bfb7341f646cdbaca62ae8daf624675e1c08e0c05ba07ef"
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
