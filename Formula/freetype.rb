class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.7.1/freetype-2.7.1.tar.bz2"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.7.1.tar.bz2"
  sha256 "3a3bb2c4e15ffb433f2032f50a5b5a92558206822e22bfe8cbe339af4aa82f88"

  bottle do
    cellar :any
    sha256 "13627ffdf46a1236bc702b1656f1fc8d95a503b515ff1b212bb4d1851d19e097" => :sierra
    sha256 "63f3945987b8dc90dc6bf456f5406b2ba70160a80a65c94caaeb2b3e0c04b2d3" => :el_capitan
    sha256 "14588ddd46a90c9df9591d1cff02953bc639b96ffec0e8274ab7703f4b9361b2" => :yosemite
  end

  keg_only :provided_pre_mountain_lion

  option "without-subpixel", "Disable sub-pixel rendering (a.k.a. LCD rendering, or ClearType)"

  depends_on "libpng"

  def install
    if build.with? "subpixel"
      inreplace "include/freetype/config/ftoption.h",
          "/* #define FT_CONFIG_OPTION_SUBPIXEL_RENDERING */",
          "#define FT_CONFIG_OPTION_SUBPIXEL_RENDERING"
    end

    system "./configure", "--prefix=#{prefix}", "--without-harfbuzz"
    system "make"
    system "make", "install"

    inreplace [bin/"freetype-config", lib/"pkgconfig/freetype2.pc"],
      prefix, opt_prefix
  end

  test do
    system bin/"freetype-config", "--cflags", "--libs", "--ftversion",
                                  "--exec-prefix", "--prefix"
  end
end
