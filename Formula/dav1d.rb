class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/0.9.0/dav1d-0.9.0.tar.bz2"
  sha256 "e0cb645f170e7a087bc76e501324177be51a8db21df22ad37b43d289d7d1f7b5"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ff2b963d4889e5061e7a9aa734f445f975cd9c9dc5fcc58693e2c84a2f18665a"
    sha256 cellar: :any, big_sur:       "aa92fc129112e67f1eec05fe15cf2ccacbe279c7391805516752c7c79b94c77c"
    sha256 cellar: :any, catalina:      "bfecc7f69601a571190066d3a24e4f1b82264667d8b5e7c8894ec5f349703961"
    sha256 cellar: :any, mojave:        "8dd4136d86ea8da33ecc3390fcf12585b3c4266cf186aa41212ca870d398ef16"
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
