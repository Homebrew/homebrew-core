class MultiGitStatus < Formula
  desc "Show uncommitted, untracked and unpushed changes for multiple Git repos"
  homepage "https://github.com/fboender/multi-git-status"
  url "https://github.com/fboender/multi-git-status/archive/refs/tags/2.1.tar.gz"
  sha256 "cef8c14992d6a6a473248fef5290858518abba5947cdad57f2e5022c7e86752a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3f2087edcb148064d057689126fedcfdd3314f086c392f6d8223b335a3a3358f"
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
