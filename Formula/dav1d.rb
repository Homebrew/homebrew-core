class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/1.1.0/dav1d-1.1.0.tar.bz2"
  sha256 "ec5f2dae9b1a7e1da44a7fc9c8fcee476e345df290c50935344bde57543a4cd6"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "09b2ecc597d2bfd42943e4f1942fe7e2345ad7bb4b73163325e9a995a44b4608"
    sha256 cellar: :any,                 arm64_monterey: "5326cd563c172c25161cbd69248b3109452cc04ffe97da757652ed75f2f7cabc"
    sha256 cellar: :any,                 arm64_big_sur:  "7d552c2b1becebf8d0c7783ed85fe63ba4cbf71cf53abe0e9a235f542691e68a"
    sha256 cellar: :any,                 ventura:        "1867e720b29df42f57cdd2644efea8c4918153f8b65af5427114db43781ac5fd"
    sha256 cellar: :any,                 monterey:       "c9cc918847005baff18a28015e6dce362f91f5edb9995540aa439734f2749b37"
    sha256 cellar: :any,                 big_sur:        "d11459b6990b9baf1e3fe19195c6e7ef4f42d9a2137351d1037f45a4e5638964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc5de59a1ecae93b8ca823f659aa8aa6d46ea47a24ab6216d0eb272406c414a8"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  resource "00000000.ivf" do
    url "https://code.videolan.org/videolan/dav1d-test-data/raw/1.1.0/8-bit/data/00000000.ivf"
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
