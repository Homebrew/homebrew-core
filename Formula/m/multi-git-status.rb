class MultiGitStatus < Formula
  desc "Show uncommitted, untracked and unpushed changes for multiple Git repos"
  homepage "https://github.com/fboender/multi-git-status"
  url "https://github.com/fboender/multi-git-status/archive/refs/tags/2.2.tar.gz"
  sha256 "d26a71cd2efd80416c28d59632665341bc393d2d5fdde20dd588f959b0faea6a"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "fac5b19bd31bb3fd744b2603b9b8f58636d6d51902a046c5d5fbcc774515d1ad"
  end

  def install
    # This is what the included 'install.sh' script does, except that
    # we use Homebrew's preferred location for 'man1'.
    bin.install "mgitstatus"
    man1.install "mgitstatus.1"
  end

  test do
    mkdir "test-repo" do
      system "git", "init"
    end
    assert_match "./test-repo: Uncommitted changes", shell_output("#{bin}/mgitstatus 2>&1")
  end
end
