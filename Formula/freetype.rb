class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sf.net/project/freetype/freetype2/2.7/freetype-2.7.tar.bz2"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.7.tar.bz2"
  sha256 "d6a451f5b754857d2aa3964fd4473f8bc5c64e879b24516d780fb26bec7f7d48"

  bottle do
    cellar :any
    sha256 "6cdebad1d3a4e6bdda41235dc69e77770ab98570d003af074f9bf2d6656d3e19" => :sierra
    sha256 "0c98beda51c7d5a42f317598a2fbb65391278f6bb72f038512033392a681b25e" => :el_capitan
    sha256 "f29056e7f47435120efd7fedfce5483e083dcf52fa587569a99d2afba3fb11c2" => :yosemite
    sha256 "470c71da601ed6b1fd95445492040e5a56f30135d1602d3617f4da89539f1b6b" => :mavericks
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

    inreplace [bin/"freetype-config", lib/"pkgconfig/freetype2.pc"],
      prefix, opt_prefix
  end

  test do
    system bin/"freetype-config", "--cflags", "--libs", "--ftversion",
                                  "--exec-prefix", "--prefix"
  end
end
