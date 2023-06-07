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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb48f4977b6fffe6260f6adf6a20b15d0e33ef6f0f70a3d5fe36f3d1cd708c3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cfe1657cc446af26bc4d3f2cf50e4a804fa98539993a007ab13b466536cda1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "902ceb61db37a6795eee8d7941a44633faa38bcd9c2a4b952bf837bab0ee6d59"
    sha256 cellar: :any_skip_relocation, ventura:        "6f87cb770bbb2cac134625c7998bd3bc0974ceaaf9d352045a5659adba6d6ae6"
    sha256 cellar: :any_skip_relocation, monterey:       "d6203a132a5f2e56a85356d5dd9c4545af59e7199b72eaca3a9571d171322d5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "75e1876579c6638c1e4c0509af5c76950ae379b034e6a051d091593cb08c1ddd"
    sha256 cellar: :any_skip_relocation, catalina:       "83df0761686086ae64a3c08433613908d9c39d85daa7f81011b5bd70d2d5eb3d"
    sha256 cellar: :any_skip_relocation, mojave:         "c503806d5f1ad449a6943275fa93a3930fbbd7cd63b31ee873590d0219ded5b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0418a37628a09a44eeb05aecca9b6fc6149dcfdf40729d4a41f754f030fac51"
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
