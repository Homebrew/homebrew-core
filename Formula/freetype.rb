class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  # Note: when bumping freetype's version, you must also bump revisions of
  # formula with "full path" references to freetype in their pkgconfig.
  # See https://github.com/Homebrew/legacy-homebrew/pull/44587
  url "https://downloads.sf.net/project/freetype/freetype2/2.6.5/freetype-2.6.5.tar.bz2"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.6.5.tar.bz2"
  sha256 "e20a6e1400798fd5e3d831dd821b61c35b1f9a6465d6b18a53a9df4cf441acf0"

  bottle do
    cellar :any
    sha256 "f0cd7f379f0d148fdad1d4e089810dd0bac6aa39fddec5e29fe0749e169c9507" => :sierra
    sha256 "9830f84e55635b445eb5422d7383ef37c76e71d4fcfd041eccd528f0580a6223" => :el_capitan
    sha256 "53ffcde03d0c0ec7c31ae45de6ff699be97357276833c3b62ce0e2270f6d6b70" => :yosemite
    sha256 "3fa3f187bca761465c8b02ccff5c4dbb13edfa9e342c246a1ca46959f37df513" => :mavericks
  end

  keg_only :provided_pre_mountain_lion

  option :universal
  option "without-subpixel", "Disable sub-pixel rendering (a.k.a. LCD rendering, or ClearType)"

  depends_on "libpng"

  def install
    if build.with? "subpixel"
      inreplace "include/freetype/config/ftoption.h",
          "/* #define FT_CONFIG_OPTION_SUBPIXEL_RENDERING */",
          "#define FT_CONFIG_OPTION_SUBPIXEL_RENDERING"
    end

    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}", "--without-harfbuzz"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/freetype-config", "--cflags", "--libs", "--ftversion",
      "--exec-prefix", "--prefix"
  end
end
