class Libkeccak < Formula
  desc "Keccak-family hashing library"
  homepage "https://github.com/maandree/libkeccak"
  url "https://github.com/maandree/libkeccak/archive/1.2.tar.gz"
  sha256 "a9fa976a601b749499f24975756f98c28edddfb5e6828c681ccde7cfcb95d5f8"

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
