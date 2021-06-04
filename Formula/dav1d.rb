class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/0.9.0/dav1d-0.9.0.tar.bz2"
  sha256 "e0cb645f170e7a087bc76e501324177be51a8db21df22ad37b43d289d7d1f7b5"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3ef3442e8d669abaa81207d3338b8718b5d0e11cc5293fd54cb87ba26e4ebb77"
    sha256 cellar: :any, big_sur:       "75ba2b6a51de06183c444e6193e33b581858cbdb60913db8e04830612fe2c202"
    sha256 cellar: :any, catalina:      "c8448e4ca0c2b1f394d10bf846f53fd36ed2eef78c72bdbb5c3241e602f16ac1"
    sha256 cellar: :any, mojave:        "b6b810290ca73343d4e8ff7505bd30431d04dbf1375eb1e84668ce93861a164f"
  end

  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build

  resource "00000000.ivf" do
    url "https://code.videolan.org/videolan/dav1d-test-data/raw/0.8.2/8-bit/data/00000000.ivf"
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
