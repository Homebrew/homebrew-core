class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/1.4.1/dav1d-1.4.1.tar.bz2"
  sha256 "ab02c6c72c69b2b24726251f028b7cb57d5b3659eeec9f67f6cecb2322b127d8"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "964144852a07c4c377a5299cd6897cd9b6afd13e1b3009f21ac412589b0f8db7"
    sha256 cellar: :any,                 arm64_ventura:  "52a1afeb3d59c50bc68fb000933d7c5ea7adb25be0f9d0f908342646005efb87"
    sha256 cellar: :any,                 arm64_monterey: "7bbf65126205634d9a43d9860933197f65da4669be4485899269db80f13f1c04"
    sha256 cellar: :any,                 sonoma:         "bc58b1388bd80f2d8fdc241847f746605d64e2cf36e3f0217428371b69403a1b"
    sha256 cellar: :any,                 ventura:        "5c067de2df31582b484651f34c2f76fff8f6d741e007a003d79cb267433d9726"
    sha256 cellar: :any,                 monterey:       "c01dd110041531bf7fd8a6631b433c8535002158814e60170af60cd0b7796b4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5972f5ae4c02e5daf2801fdda29ccd45bf18deaf409b84aca6a7d0849f8435ed"
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
