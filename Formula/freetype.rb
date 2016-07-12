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
    sha256 "9ae6bdaddd64a845d7293990c656c6b5a2d55eb0a54d787d977d92bb3a34b462" => :el_capitan
    sha256 "eb549e7f83c77a0419bfeb34e0cc965c05256b2dfa6d99b8a70df81e73b439e0" => :yosemite
    sha256 "650cfebaa6852614b76a6451fc6d9d5538a1b90a5f80c0f6006d7cf1c08a083b" => :mavericks
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
