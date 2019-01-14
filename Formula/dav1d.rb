class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/0.1.0/dav1d-0.1.0.tar.bz2"
  sha256 "923f78d17aed08252608790eaed06a3d530763168fd6a8fc74e3306d7e01e6a5"

  bottle do
    cellar :any
    sha256 "f1b2efe50ba43547c9a51e5b1190c4aad90684f83ad42275c68db7fbb82b2331" => :mojave
    sha256 "6d2163128de08761e95cc5a08864375d065f55cdc3afeb94b4dd222c9a5940d0" => :high_sierra
    sha256 "a95b01e359731fffbd55a81edaae6293d70c1111cc548dc88e6254d942eb0f31" => :sierra
  end

  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build

  resource "00000000.ivf" do
    url "https://people.xiph.org/~tterribe/av1/samples-all/00000000.ivf"
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
