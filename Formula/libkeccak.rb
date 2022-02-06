class Libkeccak < Formula
  desc "Keccak-family hashing library"
  homepage "https://github.com/maandree/libkeccak"
  url "https://github.com/maandree/libkeccak/archive/1.3.1.tar.gz"
  sha256 "f13331e014d9b0b14c2be7b834c3ca817c171cad16801e58e6f1ec5eb981a2ce"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f28fb5ca876283d73bd88bd89cdddebfdd7d8d528109f5f5230ecde499b656b3"
    sha256 cellar: :any,                 arm64_big_sur:  "fe51ee5012e9c87930e363196c8feb5cc08705713b36019da1df103172d38c9e"
    sha256 cellar: :any,                 monterey:       "97c02772e8702b9bc0f99560ac85baeea09f462e4b6d69cd7268af65efe3483e"
    sha256 cellar: :any,                 big_sur:        "d891d274be5655fb37f4527a0a6ae39dec9dffb8d07f9822fe068f2ad47b87a0"
    sha256 cellar: :any,                 catalina:       "cb4d4e1aad574126594225fc5fb55f8bed0ba8c70d3c3de504e752ed703e6d85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e67e083ddd95ffdcf6e6055a3b9233bc8f5acb48e7aa96a37b525fda97946af7"
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
