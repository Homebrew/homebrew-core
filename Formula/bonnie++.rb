class Bonniexx < Formula
  desc "Benchmark suite for file systems and hard drives"
  homepage "https://www.coker.com.au/bonnie++/"
  url "https://www.coker.com.au/bonnie++/bonnie++-2.00a.tgz"
  sha256 "a8d33bbd81bc7eb559ce5bf6e584b9b53faea39ccfb4ae92e58f27257e468f0e"
  license "GPL-2.0-only"

  livecheck do
    url "https://doc.coker.com.au/projects/bonnie/"
    regex(/href=.*?bonnie\+\+[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "902ceb61db37a6795eee8d7941a44633faa38bcd9c2a4b952bf837bab0ee6d59"
    sha256 cellar: :any_skip_relocation, big_sur:       "75e1876579c6638c1e4c0509af5c76950ae379b034e6a051d091593cb08c1ddd"
    sha256 cellar: :any_skip_relocation, catalina:      "83df0761686086ae64a3c08433613908d9c39d85daa7f81011b5bd70d2d5eb3d"
    sha256 cellar: :any_skip_relocation, mojave:        "c503806d5f1ad449a6943275fa93a3930fbbd7cd63b31ee873590d0219ded5b9"
  end

  # Remove the #ifdef _LARGEFILE64_SOURCE macros which not only prohibits the
  # intended functionality of splitting into 2 GB files for such filesystems but
  # also incorrectly tests for it in the first place. The ideal fix would be to
  # replace the AC_TRY_RUN() in configure.in if the fail code actually worked.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/913b5a25087d2c64d3b6459635d5d64012b83042/bonnie%2B%2B/remove-large-file-support-macros.diff"
    sha256 "368a7ea0cf202a169467efb81cb6649c1b6306999ccd54b85641fd4b458a46b7"
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{sbin}/bonnie++", "-s", "0"
  end
end
