class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sf.net/project/freetype/freetype2/2.6.4/freetype-2.6.4.tar.bz2"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.6.4.tar.bz2"
  sha256 "5f83ce531c7035728e03f7f0421cb0533fca4e6d90d5e308674d6d313c23074d"

  patch :DATA

  # Note: when bumping freetype's version, you must also bump revisions of formula with
  # "full path" references to freetype in their pkgconfig.
  # See https://github.com/Homebrew/homebrew/pull/44587

  bottle do
    cellar :any
    sha256 "03d81469f42b34176ad9b7a382a2ab613445541a57e3db02e80121508cc43309" => :el_capitan
    sha256 "ff8df778e420e76ac823fb5d31b3bfd1d89be87aa664bb1140bb44508f4d5e23" => :yosemite
    sha256 "ecfb1b9f4dcce361d4c40367dc205842411cbcbb6628238da571aff84caf05c3" => :mavericks
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

__END__
diff --git a/builds/exports.mk b/builds/exports.mk
index 9685f1f..d5a5085 100644
--- a/builds/exports.mk
+++ b/builds/exports.mk
@@ -40,7 +40,11 @@ ifneq ($(EXPORTS_LIST),)
   endif

   # The list of public headers we're going to parse.
-  PUBLIC_HEADERS := $(wildcard $(PUBLIC_DIR)/*.h)
+  PUBLIC_HEADERS := $(filter-out $(PUBLIC_DIR)/ftmac.h, \
+                                 $(wildcard $(PUBLIC_DIR)/*.h))
+  ifneq ($(ftmac_c),)
+    PUBLIC_HEADERS += $(PUBLIC_DIR)/ftmac.h
+  endif

   # The `apinames' source and executable.  We use $E_BUILD as the host
   # executable suffix, which *includes* the final dot.
