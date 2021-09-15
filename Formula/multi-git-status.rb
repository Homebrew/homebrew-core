class MultiGitStatus < Formula
  desc "Show uncommitted, untracked and unpushed changes for multiple Git repos"
  homepage "https://github.com/fboender/multi-git-status"
  url "https://github.com/fboender/multi-git-status/archive/refs/tags/2.0.tar.gz"
  sha256 "13ce21fc087354cd7e0fd16f332bcff7e8c42c0315d3f27803159926aff3360f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f7fede3a899bdff2736d9aa78be4efca5ec614f9983c3fb45a1f8a71abbf0dfe"
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
