class Libkeccak < Formula
  desc "Keccak-family hashing library"
  homepage "https://codeberg.org/maandree/libkeccak"
  url "https://codeberg.org/maandree/libkeccak/archive/1.4.3.tar.gz"
  sha256 "5b28b11b38cc0ea750abd8a3f9cc2463df0e475f06a7a3c3e379471dde3a3d2b"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "76d0b52421d09d7390ee5c1ecfab8a2cf5e4e6fc172e36ed2d75c0457d4db33a"
    sha256 cellar: :any,                 arm64_sequoia: "98f18e1c890f10ac9847977b9431f06a463c2c079646b478736b3c4e7e6bdb46"
    sha256 cellar: :any,                 arm64_sonoma:  "6436b47438451ee3d21c44a668efc8e3a1b4c6572fbca312386eacd16e90c26d"
    sha256 cellar: :any,                 sonoma:        "f9cc552ba41aeab13af7891a9c41ae1beaf268ce8024db38820b8665240e7954"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32b32420cd4b89364da22635402652e1ba6d1b74fcc68dab229915e76e1f9597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7efd8af258f42baf7e3b243eb9463ebeeb97272330737cc4b40324b7a967a114"
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
