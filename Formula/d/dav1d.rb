class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/1.5.2/dav1d-1.5.2.tar.bz2"
  sha256 "c748a3214cf02a6d23bc179a0e8caea9d6ece1e46314ef21f5508ca6b5de6262"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "51d9f8e8087862533fde9901158fb784bed69ecdd74b4aea75879ec068a7fa94"
    sha256 cellar: :any,                 arm64_sequoia: "606c3c39ebbc55f12524f3688148441fc1c699f2e0f15afad248eed30b95c73b"
    sha256 cellar: :any,                 arm64_sonoma:  "04256162edd9c60143369b2e12434ab380818a1f4fc5ad6aeb9c1d9699567b4a"
    sha256 cellar: :any,                 sonoma:        "186f73868478cc6a624c80ef01b0d65f3526b606f4f63e0ef1b6a7f93894b2a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2f4a237c9208f3666398ccec5288d71a5c7bc3e18b9f5b273cf5c520771c2c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a234b082021158b85cc97bd0587acf1bd3b4e2712fcc31c66c21364bb426a4be"
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
