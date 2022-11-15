class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/1.0.0/dav1d-1.0.0.tar.bz2"
  sha256 "4a4eb6cecbc8c26916ef58886d478243de8bcc46710b369c04d6891b0155ac0f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8fdc81bd7aba4e4ec7b06e6eb3cc38db6c789ef079d87fa1cf3c2891e9a42d1c"
    sha256 cellar: :any,                 arm64_monterey: "ed488f61f6809e006ff1ab3557ba1ea6bbd89c12ea47782afdeca1b01f6f2d18"
    sha256 cellar: :any,                 arm64_big_sur:  "0e15f91e99bd1a41408ea7d2773b2676e4339a4d369bb8de0b9be6b1dd0a1bec"
    sha256 cellar: :any,                 ventura:        "67d10c5e36161d0a5e7a5c752c7883a62bf6c750b58fc7a0d3a8eb920183edb7"
    sha256 cellar: :any,                 monterey:       "c50893e5d767b31380e5dff32c1d934d345fa8656d794efbbf0be937f9bd5cd1"
    sha256 cellar: :any,                 big_sur:        "c194ecbe7768aa96b0d29094ef9d355f0b585d0281f705cb9d9bdf429591be51"
    sha256 cellar: :any,                 catalina:       "4025ff5fb02272858f31890fba825eb440cf2f341de4be2e73505a608ba436e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02f0a49f6230ccc27eade0cffcc2e502eb22bfed8abe5430285bdab7276346f6"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  resource "00000000.ivf" do
    url "https://code.videolan.org/videolan/dav1d-test-data/raw/1.0.0/8-bit/data/00000000.ivf"
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
