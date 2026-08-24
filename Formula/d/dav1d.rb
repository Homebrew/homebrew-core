class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/1.5.4/dav1d-1.5.4.tar.bz2"
  sha256 "2abfb0c89212e6e4733a54e0ae509ec00a5b845a6360946f918806e14aedb011"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d30ff747564febd643ec4b279c5adc74f708b8d6eb8e172f914b9fcdec26c464"
    sha256 cellar: :any, arm64_sequoia: "5f573db161c0685ba7e8d27bd3b6a494e6952e47c7c99355a0d090b253b566af"
    sha256 cellar: :any, arm64_sonoma:  "0ac81e374a2bf69706ddef7f8ea18ca7188eb51eb31689a4198a6d257a69af2c"
    sha256 cellar: :any, sonoma:        "c6bf6ecc82c9ede74528fbf82ddf4b9c83bf6eb7c74dcf5e5a56a25b4cb918d5"
    sha256 cellar: :any, arm64_linux:   "f67e0d83c7f0ee6a8a68a5cf56253736b9b20d29d479da9d5446aa3cea467c3b"
    sha256 cellar: :any, x86_64_linux:  "6c978ac8a5eb6652bd8780911ff45d73a181e6c6a9f18d60f1c7f86184d4bdb2"
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

    assert_path_exists (testpath/"00000000.md5")
    assert_match "0b31f7ae90dfa22cefe0f2a1ad97c620", (testpath/"00000000.md5").read
  end
end
