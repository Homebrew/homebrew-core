class Bonniexx < Formula
  desc "Benchmark suite for file systems and hard drives"
  homepage "https://www.coker.com.au/bonnie++/"
  url "https://www.coker.com.au/bonnie++/bonnie++-1.98.tgz"
  sha256 "6e0bcbc08b78856fd998dd7bcb352d4615a99c26c2dc83d5b8345b102bad0b04"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6efac6fef771ca5d88fd4f8157e185e120c5e6935f9d940f2c6c3d5c9564ce0" => :catalina
    sha256 "af6277fc9f23e9665b134aa2790dc30ebdaba386492c1832bf88a1f67280c63c" => :mojave
    sha256 "50872a4a0cbca4eecb515214f23efe7eb5e421dbbbe406a5e95a7bd62e4f9d34" => :high_sierra
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
