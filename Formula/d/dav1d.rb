class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/1.5.3/dav1d-1.5.3.tar.bz2"
  sha256 "e099f53253f6c247580c554d53a13f1040638f2066edc3c740e4c2f15174ce22"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cda8a6b7d3184cb2a083b8629ae5f9b00f8e04b36da71d8f56f149cbdeebfdbf"
    sha256 cellar: :any,                 arm64_sequoia: "9502a86f722756284734b724206d21783a0863406462abf8d43fe52d5232bad5"
    sha256 cellar: :any,                 arm64_sonoma:  "fe0db93877e6734a127c1cb8dd98293d2016b830fd2ec36fb8985e36e92d7611"
    sha256 cellar: :any,                 sonoma:        "8697d509b54358c4ad2b8a370841ee5244431d2d85c2883bb7624f60c59ec7b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89f1cacc3d5d6de20cd85b098e0abed0eaf552dbda07cb3715cf06decf5c1fcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8dae4c806758642d9e2dc6d064b0f62dd7b692c951c2bba171394ac94e69a8d"
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
