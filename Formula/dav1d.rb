class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/0.9.1/dav1d-0.9.1.tar.bz2"
  sha256 "fb2a050e6c2410c99104f631e202a02697dfe1a2fc9acc3c50a16422aefb004c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "8e670d0b361c6af5202765c6ccafb08dedac3f753f9f82c8b3c7aaa3bf9a475c"
    sha256 cellar: :any,                 big_sur:       "816f72fd14b4f4825a758c404c3ae2407de73084fc4196d51eb7ac4c2fb7911d"
    sha256 cellar: :any,                 catalina:      "49d2f02c9b3114fe75cc9f47d74f4fcafadf51b863101bdfd8a00474f0d7b657"
    sha256 cellar: :any,                 mojave:        "10d39319ef14d61efe30a236478dfc73da4cffb9deaf8d9c90d25047737e5739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bf500cb1256e0f4e29a85b4c26c5dda7c1d8f3d51fef51988d5bc885ed14a9c"
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
