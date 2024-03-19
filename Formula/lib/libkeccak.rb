class Libkeccak < Formula
  desc "Keccak-family hashing library"
  homepage "https://codeberg.org/maandree/libkeccak"
  url "https://codeberg.org/maandree/libkeccak/archive/1.4.tar.gz"
  sha256 "dcf148f64d49a8146c437cb532ad418030e0cde9d39ec34a454542e6321cb7a0"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1d532f8660167b1e40c7e33b60e0e08eb7a68658cbb29f78ea079ed555e7e83f"
    sha256 cellar: :any,                 arm64_ventura:  "229f095585610ccb928e3f357c19f6f8f69d8e0665aaa7f37d66bc6a47c31b9f"
    sha256 cellar: :any,                 arm64_monterey: "6dc88c48c1034dfae26c331dca47b25e78dd703a5189b54afba0ab8581a76da0"
    sha256 cellar: :any,                 arm64_big_sur:  "3027f0870675f39b458b59567e8532718df7c97c0980e7bce8ebd7b37ee7d9a6"
    sha256 cellar: :any,                 sonoma:         "cc976c7f61e1552046db49a47291e9a12074189cda692c49f494c00cc30e5831"
    sha256 cellar: :any,                 ventura:        "f3f373a75ae49059c2889de0f03ec5563420cbd7cdb2afec60d54ce8b9dca4e5"
    sha256 cellar: :any,                 monterey:       "7d82330878eeae42738295ae7c04f61d983f4f98815990bb911167738821895c"
    sha256 cellar: :any,                 big_sur:        "6a8a78e18b258495da04a992a3856e327b1e3a71e96b0e550bb4412be62d66b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba306ce017e0bd36ffc65dced2c59b2f44ae1644c54f6e74f8cb04d3b1faad7b"
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
