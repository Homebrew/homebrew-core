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
    rebuild 1
    sha256 "125b0a1b01353c1181aa3520cca321baf6c1867efbdeb26ef9b515b6c432bab2" => :el_capitan
    sha256 "cb9535e367ef3dd3d3dae797be726989908dcaae60bc1e41cb9125ff345c7675" => :yosemite
    sha256 "8dbeb926c57a5c9bdfaabca06cedbbf4f07a2011b064b99ea8b2fdb60ae8fa97" => :mavericks
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
    system "#{bin}/freetype-config", "--cflags", "--libs", "--ftversion",
      "--exec-prefix", "--prefix"
  end
end
