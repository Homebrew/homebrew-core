class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.9/freetype-2.9.tar.bz2"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.9.tar.bz2"
  sha256 "e6ffba3c8cef93f557d1f767d7bc3dee860ac7a3aaff588a521e081bc36f4c8a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "afb5bc6218adcf0c0794ede89e5db330caea397159a92469a188f10cf7835228" => :high_sierra
    sha256 "a58d00c7f3f82776024e146b0ce704edb9125cb493fca553620559389126fce6" => :sierra
    sha256 "c1283252fcb30f5407c22b3c68bf670227f5703459c238deae568f25e5fd77c5" => :el_capitan
  end

  depends_on "libpng"

  def install
    # Enable sub-pixel rendering (ClearType)
    inreplace "include/freetype/config/ftoption.h",
      "/* #define FT_CONFIG_OPTION_SUBPIXEL_RENDERING */",
      "#define FT_CONFIG_OPTION_SUBPIXEL_RENDERING"

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
