class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/1.3.0/dav1d-1.3.0.tar.bz2"
  sha256 "bde8db3d0583a4f3733bb5a4ac525556ffd03ab7dcd8a6e7c091bee28d9466b1"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c1ee846123e2afe3d336f0a857b1a7057e2623d1b5fce24adf743e0a50185ed0"
    sha256 cellar: :any,                 arm64_ventura:  "6e6f9a4347a07287d9649296ba3869740f4e4c01c2cc72337fea97b727b4e5cd"
    sha256 cellar: :any,                 arm64_monterey: "4094bfec75dd9d4882b4c64de01f02ecb6fb3f276057fd4d4b68e4e866790a66"
    sha256 cellar: :any,                 arm64_big_sur:  "2d039d7cc3ed14f6d02c56f992855814d63b8d3dc5a6b81673a3216c69fcf356"
    sha256 cellar: :any,                 sonoma:         "66936f06427043cb7613bcae738ec937347132fed200d6f4f64594970d3f8355"
    sha256 cellar: :any,                 ventura:        "4f5ced0cc79911fe4e27e56e092e1a2414748ad59ea5c52a9f186c09427f1469"
    sha256 cellar: :any,                 monterey:       "5fc42888f64d5a7138c2246c7ff98dd1940bb7a47ecc0415616b0c232e2f8891"
    sha256 cellar: :any,                 big_sur:        "cce7e0c46ad8f826eb7c1e12340e77a5cc699522968edfc619bf093bbc9ff80e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1091a61449a45f062bb16d17d84fd09e966d5fa7ba5513492cd28b78586eeb8"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    resource "homebrew-00000000.ivf" do
      url "https://code.videolan.org/videolan/dav1d-test-data/raw/1.1.0/8-bit/data/00000000.ivf"
      sha256 "52b4351f9bc8a876c8f3c9afc403d9e90f319c1882bfe44667d41c8c6f5486f3"
    end

    testpath.install resource("homebrew-00000000.ivf")
    system bin/"dav1d", "-i", testpath/"00000000.ivf", "-o", testpath/"00000000.md5"

    assert_predicate (testpath/"00000000.md5"), :exist?
    assert_match "0b31f7ae90dfa22cefe0f2a1ad97c620", (testpath/"00000000.md5").read
  end
end
