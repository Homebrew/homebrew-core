class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/0.7.1/dav1d-0.7.1.tar.bz2"
  sha256 "9eac4f50089f54a9f562827bda4a21187d68c01d8b20055eef1d7efca9f84cf8"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "72583c13b3f1a20ebf5bb51a44d23e29cbb19de60ee3cd9b2530dfd5f3061283" => :catalina
    sha256 "457283e7f7e3066bcbacff2fda7c7630ccd476dc34908ab1e150f759d88dbe42" => :mojave
    sha256 "9cadd5bf4b109037700161dcc12376d5f05a6ba73df925c592a01392f2247db6" => :high_sierra
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
