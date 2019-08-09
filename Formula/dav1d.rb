class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/0.4.0/dav1d-0.4.0.tar.bz2"
  sha256 "18bf96c5168b8c704422387620fefaa953e8dbd4eacb0f0796c03d6e741f8924"

  bottle do
    cellar :any
    sha256 "c803d7a944d1736036e79a1697c8b876d4df60e7955f8b5d2c19c7768d090ea4" => :mojave
    sha256 "6944cc68ae74cd7e96984a6c4e82248ace079c3b000e08b280437fc26a438e06" => :high_sierra
    sha256 "f00200b7408ec66a9ffcc7f0502b54b8865600d9e5d3c6ef1a0d43e5330b2145" => :sierra
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
