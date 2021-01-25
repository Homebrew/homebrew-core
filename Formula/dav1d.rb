class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/0.8.1/dav1d-0.8.1.tar.bz2"
  sha256 "842da2945afcf54e651d17112bf2823a238e6c935a6c8dff3a8e96a2eb740269"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "19b36dac5e316943575c177e8b48dce7a19dffc62e82b295c1850def41a7f91f" => :big_sur
    sha256 "5d7706832799921efd814f3f56f8a77a1004e254ea75c97a0c993c0a2577136a" => :arm64_big_sur
    sha256 "3dfee035e136d79127501d4a22c169ab4b0a832a5300591a0145c075220bac91" => :catalina
    sha256 "5a3f58f18e7314616a9d8f8b8de4675674f451fda032fd9e6dc07a8ce37c4b43" => :mojave
  end

  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build

  resource "00000000.ivf" do
    url "https://code.videolan.org/videolan/dav1d-test-data/raw/master/8-bit/data/00000000.ivf"
    sha256 "52b4351f9bc8a876c8f3c9afc403d9e90f319c1882bfe44667d41c8c6f5486f3"
  end

  def install
    system "meson", *std_meson_args, "build"
    system "ninja", "install", "-C", "build"
  end

  test do
    testpath.install resource("00000000.ivf")
    system bin/"dav1d", "-i", testpath/"00000000.ivf", "-o", testpath/"00000000.md5"

    assert_predicate (testpath/"00000000.md5"), :exist?
    assert_match "0b31f7ae90dfa22cefe0f2a1ad97c620", (testpath/"00000000.md5").read
  end
end
