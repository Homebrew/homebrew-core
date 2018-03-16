class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.9/freetype-2.9.tar.bz2"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.9.tar.bz2"
  sha256 "e6ffba3c8cef93f557d1f767d7bc3dee860ac7a3aaff588a521e081bc36f4c8a"

  bottle do
    cellar :any
    sha256 "2978dbec18cf06827ddc93ee04262bc3f78b14a9ed2e91058b53a8a997f81451" => :high_sierra
    sha256 "8680a89d47fa9eea998d230ec1f7d39422f87fc3152a0ab3b6b936832d9a154e" => :sierra
    sha256 "1e66987caa45ffcbe3cd18924f7b1a82c37207a23c89085d27ad3008df5ef914" => :el_capitan
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
