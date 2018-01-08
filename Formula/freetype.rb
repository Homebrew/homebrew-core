class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.9/freetype-2.9.tar.bz2"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.9.tar.bz2"
  sha256 "e6ffba3c8cef93f557d1f767d7bc3dee860ac7a3aaff588a521e081bc36f4c8a"

  bottle do
    cellar :any
    sha256 "603b19cb3d0e8ae6ddc040a3a148a0ab66f605958d1afcf95c3411b11be00c70" => :high_sierra
    sha256 "ad1a02a75cc736f17f340e1bcc4aca154ac7c5505e1f54e61b1a72b0b5ef07c8" => :sierra
    sha256 "a0949e817a31d3c8a39bca2cdaf283c5a5e538c9c6786214369848fafffb0c0f" => :el_capitan
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
