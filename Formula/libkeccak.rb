class Libkeccak < Formula
  desc "Keccak-family hashing library"
  homepage "https://github.com/maandree/libkeccak"
  url "https://github.com/maandree/libkeccak/archive/1.2.tar.gz"
  sha256 "a9fa976a601b749499f24975756f98c28edddfb5e6828c681ccde7cfcb95d5f8"

  bottle do
    cellar :any
    sha256 "a6c562298b9f840a535e67c4a1af2cd2cee7a64b148867dffbd5c43abe449fac" => :catalina
    sha256 "62bef7ab66b3080369802009fce876879f6a756fc6f2734de0e33a514fa8bf93" => :mojave
    sha256 "802c42ae842ebed113639b7e647da9eb09d8fddde91b9d2938652849f2543a06" => :high_sierra
    sha256 "0c505d90e236906a294afbd5989a79e503c4ae2afbfa3a8727ffb96969b4a6c9" => :sierra
  end

  def install
    system "make", "install", "OSCONFIGFILE=macos.mk", "PREFIX=#{prefix}"
    pkgshare.install %w[.testfile test.c]
  end

  test do
    cp_r pkgshare/".testfile", testpath
    system ENV.cc, "-std=c99", "-O3", "-o", "test", pkgshare/"test.c", "-L#{lib}", "-lkeccak", "-s"
    system "./test"
  end
end
