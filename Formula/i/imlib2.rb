class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.13.0/imlib2-1.13.0.tar.gz"
  sha256 "97c2ae4401f0a338d2990704a3b71af9a5a0468a8c5d387eb108f2ca1527f4ce"
  license "Imlib2"
  compatibility_version 1

  bottle do
    sha256 arm64_golden_gate: "d6ebbe07332d273b036e21081b15a36ebfc39367e2a1b0e3ffa2d29b5ea1a823"
    sha256 arm64_tahoe:       "d9dfbf6f483a2bc8c60ee8ef1bc2a0b04c39c8f0716b6600a339cd785050e1bf"
    sha256 arm64_sequoia:     "53a037e4c07768b6b0ce5feebc078074a62bb374dc7d74f08159b27cd000f13f"
    sha256 arm64_linux:       "bdbd9277c7e10a9cc31793a4920f282c15217481ccd3a0cff8a8e9ba124dbd37"
    sha256 x86_64_linux:      "cae14dfcb52c6b6712409a97fe640d3d52d4a5c5d4f8830bcd672888ca03d4ae"
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

  deny_network_access!

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
