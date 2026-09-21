class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.12.7/imlib2-1.12.7.tar.gz"
  sha256 "b863d4c7130261d5256471a15106feb57b53d15e15fc7f52ece9af92e291eec7"
  license "Imlib2"
  compatibility_version 1

  bottle do
    sha256 arm64_golden_gate: "f8a1b2ba0d46b6a7305ae79469893b03a481abf0a0c9e377bbad240c2eaa063e"
    sha256 arm64_tahoe:       "ed575055879ef307ea3d012201ee15f0b545b7cf553b38c4ad3e22ac3d9a6ab0"
    sha256 arm64_sequoia:     "9d7d7bdb608e59f0a27380be261ba283bcd53ea15d4cbc1160f18a8b5fe61aa9"
    sha256 arm64_sonoma:      "9679cea52d1bb52d73ef8bc31a1c5a3f349cc05a13f5d3bd02b5a40b0dbee07a"
    sha256 arm64_linux:       "7299dab1dbab2f1496910c247982e0cf526bac36c9364b4da5d1dd99492410a3"
    sha256 x86_64_linux:      "f18fb382e996bf5c3b1501fd51ddfb15f81a0b7199d5fd5abcd46a58265d30c3"
  end

  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "xz"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--enable-amd64=no",
                          "--without-heif",
                          "--without-id3",
                          "--without-j2k",
                          "--without-jxl",
                          "--without-ps",
                          "--without-svg",
                          "--without-webp",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"imlib2_conv", test_fixtures("test.png"), "imlib2_test.png"
  end
end
