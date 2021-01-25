class GitFresh < Formula
  desc "Utility to keep git repos fresh"
  homepage "https://github.com/imsky/git-fresh"
  url "https://github.com/imsky/git-fresh/archive/v1.13.0.tar.gz"
  sha256 "7043aaf2bf66dade7d06ebcf96e5d368c4910c002b7b00962bd2bd24490ce2dc"
  license "MIT"

  bottle :unneeded

  def install
    system "./install.sh", bin
    man1.install "git-fresh.1"
  end

  test do
    system "#{bin}/git-fresh", "-T"
  end
end
