class GitFresh < Formula
  desc "Utility to keep git repos fresh"
  homepage "https://github.com/imsky/git-fresh"
  url "https://github.com/imsky/git-fresh/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "7043aaf2bf66dade7d06ebcf96e5d368c4910c002b7b00962bd2bd24490ce2dc"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2ef148bdcba28587b794c4a63178151165c088648dcedda3fc6ecb1bd1ecf09e"
  end

  def install
    system "./install.sh", bin
    man1.install "git-fresh.1"
  end

  test do
    system "git", "config", "--global", "init.defaultBranch", "master"
    system bin/"git-fresh", "-T"
  end
end
