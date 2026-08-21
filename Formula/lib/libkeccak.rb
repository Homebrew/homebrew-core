class Libkeccak < Formula
  desc "Keccak-family hashing library"
  homepage "https://codeberg.org/maandree/libkeccak"
  url "https://codeberg.org/maandree/libkeccak/archive/1.4.3.tar.gz"
  sha256 "e395732342c9a6cbc22d709434a9d7b40f7b958952e9061ec09ec6d80d7ce83f"
  license "ISC"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "b81a5c31bab9c20bdda40840bed85b7c2c7e4b7c6dcfdcf16c8092d2eac56900"
    sha256 cellar: :any, arm64_sequoia: "e2f6aaa634828a1954117730a8aa2f81d4e79fcf0a5d5032b54731a4e656903f"
    sha256 cellar: :any, arm64_sonoma:  "0f88726e336f736319b6f46f343cc7c02c3b293dd7c8aad58e137e6c0dce09bb"
    sha256 cellar: :any, sonoma:        "7783b2238e8d92d7647293687bb36ed38f9fd5ddec7067e4f2861c724169d4cc"
    sha256 cellar: :any, arm64_linux:   "5932d21b43bab0e1cc6955297d32152d2a15662f33cc67e21e7b278e04bd7af7"
    sha256 cellar: :any, x86_64_linux:  "04f32f167de0e89b94e6bb687b88be23514ef88dc221afbd4ef894d5002553bc"
  end

  def install
    args = ["PREFIX=#{prefix}"]
    args << "OSCONFIGFILE=macos.mk" if OS.mac?

    system "make", "install", *args
    pkgshare.install %w[.testfile test.c]
  end

  test do
    cp_r pkgshare/".testfile", testpath
    system ENV.cc, pkgshare/"test.c", "-std=c99", "-O3", "-I#{include}", "-L#{lib}", "-lkeccak", "-o", "test"
    system "./test"
  end
end
