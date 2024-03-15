class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/1.4.1/dav1d-1.4.1.tar.bz2"
  sha256 "ab02c6c72c69b2b24726251f028b7cb57d5b3659eeec9f67f6cecb2322b127d8"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "03efb80ff191a4709150561e0e1707a9b30018f6c96807009e4dcb8d744591b6"
    sha256 cellar: :any,                 arm64_ventura:  "2fa9a346ca5c7fc9efa1fae9bdf00bd09c0b95c93b066dd59f5da1b9bf79c79d"
    sha256 cellar: :any,                 arm64_monterey: "7e246f7e18345ddbb91c2fac65878bf0bfee77e5e698fa9eb20502fa81418ba5"
    sha256 cellar: :any,                 sonoma:         "3df19b677b46edd224eb10578cc1a257710a0901ea7d1882b639a69523db3318"
    sha256 cellar: :any,                 ventura:        "5b3517c99632d35b3890639285c615ff21b0ed021df9954968c77387e23734e7"
    sha256 cellar: :any,                 monterey:       "ec471ee2f6dfd06fcba4b4c7b91566c26f2f5a083ab249afef67016637aa3501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cce82eb5a95b9378ea7e601a0b0ddd6105523cdbd7626da34b29ee6e73faf00"
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
