class Libkeccak < Formula
  desc "Keccak-family hashing library"
  homepage "https://github.com/maandree/libkeccak"
  url "https://github.com/maandree/libkeccak/archive/1.3.1.2.tar.gz"
  sha256 "c17df59e038f9f1b0f09aa79944ba572f5c4efcbfe8bc6bc7aae1b40f035abe9"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "19566993fa3ce2961cafa4c36033a573138756214694c15ef39e92022edabe3d"
    sha256 cellar: :any,                 arm64_monterey: "173746b4543bc13ef45d1e4dfb8c6bb4d4249c25830f53f943898ac7ae1f81f2"
    sha256 cellar: :any,                 arm64_big_sur:  "6fc14f2ea3a381b9e9e58578bcef407cef4af0bd931da39e2e84d28a8340ab54"
    sha256 cellar: :any,                 ventura:        "94671b691bb20f6f71451b23ad2ec99441d0e1ad08fe790fc423431f60c123b0"
    sha256 cellar: :any,                 monterey:       "ce7fee03661fde649e34fbc9574283f7e69d15bde1af456cb8b05b774266ca8f"
    sha256 cellar: :any,                 big_sur:        "d7d2c628b5dbed7332389146686bebfd44d96cfec3fed0ea61df9fb0907ace4b"
    sha256 cellar: :any,                 catalina:       "c3b5014399a99a2b14d44c201e389e187ba49d32190134a3c1b8458caa6368ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5873b5c5daf987e21fab9cc6fc11a516f5654d60d6ec4789c0da3dfba436379"
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
