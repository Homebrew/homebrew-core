class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/0.6.0/dav1d-0.6.0.tar.bz2"
  sha256 "7fcfb4d2e43681f99faaad29d2a81c0ecc42d6e2b94eb4d1fded4e9dcb3661f1"

  bottle do
    cellar :any
    sha256 "641ac33fb5be462a13207c4265c080f59e1d8285826ecce8a979ac9682abf177" => :catalina
    sha256 "66de5c39d36993041daf67d014e65d56829178862e4f0969c59e1e0417e78e0a" => :mojave
    sha256 "e3384dbba22b7210feeaaeee2dee0409b7cc12841f56ae2e2040c6e32b4e94de" => :high_sierra
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
