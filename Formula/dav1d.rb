class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/0.2.1/dav1d-0.2.1.tar.bz2"
  sha256 "887f672f0afad9ff66735997e4d55d03b72a098238e291ecb17ae529adc7dd23"

  bottle do
    cellar :any
    sha256 "980226a7f72417587b363e1b2cc50d030933ee45b99ed540deeb7551d869b69d" => :mojave
    sha256 "8f33230eca60063c0b207c688b7b39cd6000d02cbabe746d1b32e8402108870c" => :high_sierra
    sha256 "fa6efd99966022d742b4d1606b63edfe05963896965ecfd8bcd7648acaaa1a25" => :sierra
  end

  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build

  resource "00000000.ivf" do
    url "https://code.videolan.org/videolan/dav1d-test-data/raw/master/8-bit/data/00000000.ivf"
    sha256 "52b4351f9bc8a876c8f3c9afc403d9e90f319c1882bfe44667d41c8c6f5486f3"
  end

  def install
    system "meson", "--prefix=#{prefix}", "build", "--buildtype", "release"
    system "ninja", "install", "-C", "build"
  end

  test do
    testpath.install resource("00000000.ivf")
    system bin/"dav1d", "-i", testpath/"00000000.ivf", "-o", testpath/"00000000.md5"

    assert_predicate (testpath/"00000000.md5"), :exist?
    assert_match "0b31f7ae90dfa22cefe0f2a1ad97c620", (testpath/"00000000.md5").read
  end
end
