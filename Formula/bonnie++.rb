class Bonniexx < Formula
  desc "Benchmark suite for file systems and hard drives"
  homepage "https://www.coker.com.au/bonnie++/"
  url "https://www.coker.com.au/bonnie++/bonnie++-1.98.tgz"
  sha256 "6e0bcbc08b78856fd998dd7bcb352d4615a99c26c2dc83d5b8345b102bad0b04"

  bottle do
    cellar :any_skip_relocation
    sha256 "5cbcfb584a1cb5fca9b42bee4e0e61ee9496ca0290937a6e5909c4dbac1794f4" => :catalina
    sha256 "6547a5df668f438110419012a9437d2986751575473d03719e08de93466e99c7" => :mojave
    sha256 "2039ecd2ab2e7a9cef39e603558aa792942f50e27b5ee3054bd39a66a2ba30a3" => :high_sierra
    sha256 "3141753fc2d81aba9129baa76946cb4f2c4cef7ca634c30d86a4b284bfe6480a" => :sierra
    sha256 "fd00a22a9744919520bdfd22f01e2ad07d409fbf76a3470b3a9a4c94f06901ed" => :el_capitan
    sha256 "0607ae5fac5e62bdfd04b48a524277768145f7ab7f07e2d2f71b6c4b6b40f9eb" => :yosemite
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
