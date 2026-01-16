class Exiftran < Formula
  desc "Transform digital camera jpegs and their EXIF data"
  homepage "https://www.kraxel.org/blog/linux/fbida/"
  url "https://www.kraxel.org/releases/fbida/fbida-2.14.tar.gz"
  sha256 "95b7c01556cb6ef9819f358b314ddfeb8a4cbe862b521a3ed62f03d163154438"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://www.kraxel.org/releases/fbida/"
    regex(/href=.*?fbida[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "47382320dca8114cb256770c2bca548abc28281ed6b90b309d62e6cfcd7cf2f5"
    sha256 cellar: :any,                 arm64_sequoia:  "66bbdb1194918c7a35edce9ec143a5ff05cc719e129e6e613cd5e600da2fbced"
    sha256 cellar: :any,                 arm64_sonoma:   "53793d2d72884e10ddf5d26a6af3b0c4b3fe28f8b28e4f96127612a2ca5c1a44"
    sha256 cellar: :any,                 arm64_ventura:  "00bbfab43b25d8747630f7a724302fa81a0cf142872c015e5083b24773678cf2"
    sha256 cellar: :any,                 arm64_monterey: "102fc92b15a47eaa70d675d6ab35dc54376dafa8f094acebc48178307f969064"
    sha256 cellar: :any,                 arm64_big_sur:  "6d4edb4e74112bc2835d5a096a689e7cb556d9ef58f1169de616151aee9e69f3"
    sha256 cellar: :any,                 sonoma:         "4267824506175ba35297c38e433a1ee8ec5118dec80f8763e604c08a8ab8256b"
    sha256 cellar: :any,                 ventura:        "5b325ba44ebed23f36442ac9379a33d4d71ca3a8f392997bfec59edd3b47660e"
    sha256 cellar: :any,                 monterey:       "4f5803bd4cca5cca2fdaa1a60acd163e46bfc16eb311c562ed05d2c5d949197c"
    sha256 cellar: :any,                 big_sur:        "64c65cb5b823a3b5b6d341a32bffee78a90d17dfbd1e07a9edef9df828025c63"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4f296de064b124fe142cf3975b32c59b162325f9dbb177ab13b12e6bd8fecdf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d32a9b73cd9ea5dca9d5a34ce6e9b6c9684ae38617045fd87b172d5d9ac6a75"
  end

  depends_on "pkgconf" => :build

  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "pixman"

  on_linux do
    depends_on "cairo"
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "ghostscript"
    depends_on "giflib"
    depends_on "libdrm"
    depends_on "libepoxy"
    depends_on "libpng"
    depends_on "libtiff"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxpm"
    depends_on "libxt"
    depends_on "mesa"
    depends_on "openmotif"
    depends_on "poppler"
    depends_on "webp"
  end

  # Fix build on Darwin
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/exiftran/fix-build.diff"
    sha256 "017268a3195fb52df08ed75827fa40e8179aff0d9e54c926b0ace5f8e60702bf"
  end

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `...'; ....o:(.bss+0x0): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    system "make"
    system "make", "prefix=#{prefix}", "RESDIR=#{share}", "install"
  end

  test do
    system bin/"exiftran", "-9", "-o", "out.jpg", test_fixtures("test.jpg")
  end
end
