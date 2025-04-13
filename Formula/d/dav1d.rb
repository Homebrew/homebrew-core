class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/1.5.1/dav1d-1.5.1.tar.bz2"
  sha256 "4eddffd108f098e307b93c9da57b6125224dc5877b1b3d157b31be6ae8f1f093"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2cfb486c742fb8c46159b99a193f3c1ae221e7d460df6a01a0daf1bb33de0bb8"
    sha256 cellar: :any,                 arm64_sonoma:  "1c9d516532c87c8a065e4d98750a3a2d187c1f89f4ddb569315a61055e7ada5d"
    sha256 cellar: :any,                 arm64_ventura: "554aac9fa65b6d94e721c59a4974182d1d77e5be4ebc31f1408ec1e3fe460ae2"
    sha256 cellar: :any,                 sonoma:        "0eab150c56858a839a017d529f909abbd7c83092a8815d21e51787e060e79b4f"
    sha256 cellar: :any,                 ventura:       "d92bf92c696541ec5e5455329f4deb851098ee60203067992b5b28e40e375446"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15ef0f5a59a18f57a8af1f2b50d5fda7c85ccb47e9d7b8040a6315d73d7f90f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a75a20ce3d5e586d5778c2a0a324175833352e2cc66ce2eff796dfec55fc867e"
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
