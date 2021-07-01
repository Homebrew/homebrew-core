class MultiGitStatus < Formula
  desc "Show uncommitted, untracked and unpushed changes for multiple Git repos"
  homepage "https://github.com/fboender/multi-git-status"
  url "https://github.com/fboender/multi-git-status/archive/refs/tags/2.0.tar.gz"
  sha256 "13ce21fc087354cd7e0fd16f332bcff7e8c42c0315d3f27803159926aff3360f"
  license "MIT"

  def install
    # This is what the included 'install.sh' script does, except that
    # we use Homebrew's preferred location for 'man1'.
    bin.install "mgitstatus"
    man1.install "mgitstatus.1"
  end

  test do
    system "#{bin}/mgitstatus", "--version"
  end
end
