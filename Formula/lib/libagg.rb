class Libagg < Formula
  desc "High fidelity 2D graphics library for C++"
  homepage "https://agg.sourceforge.net/antigrain.com/"
  # Canonical URL inaccessible: https://antigrain.com/agg-2.5.tar.gz
  url "https://ftp.osuosl.org/pub/blfs/8.0/a/agg-2.5.tar.gz"
  sha256 "ab1edc54cc32ba51a62ff120d501eecd55fceeedf869b9354e7e13812289911f"
  license "GPL-2.0-or-later"
  revision 1

  # The homepage for this formula is a copy of the original and was created
  # after the original was discontinued. There will be no further releases of
  # the copy of this software used in the formula, as the developer is deceased.
  # New development of libagg occurs in a fork of v2.4 and can be found at:
  # https://sourceforge.net/projects/agg/
  livecheck do
    skip "No longer developed/maintained"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "317463b1e1bc918e340935b5f8d4069df1a044ba7bd1e9607c9c9c6f1ea5ab48"
    sha256 cellar: :any,                 arm64_sequoia:  "057104fa9a817af5b41e424b9faa49446cc8c40b4d61c41186afd3a71e7e2e2c"
    sha256 cellar: :any,                 arm64_sonoma:   "eabb00483a8c5c955cc4f4b6351692d4c97709c7a1a14cf465767c7d52c132a7"
    sha256 cellar: :any,                 arm64_ventura:  "65786b5cc83db391b6f39b5032498024cd710832705934d34030f780bd239914"
    sha256 cellar: :any,                 arm64_monterey: "397cc6cc076ad6e8105a1888112e7e0c5cc310d4f192ad2f3b479eb13a41c4b3"
    sha256 cellar: :any,                 arm64_big_sur:  "fe56ee8021062f9fc853290fa07ffbcc9adab30eeffd566cbdbb041fca7d5044"
    sha256 cellar: :any,                 sonoma:         "fdf64bc8570ca6c042299e9f40486aeb6f510327406e5ece26f67ecc41d6075d"
    sha256 cellar: :any,                 ventura:        "4c449bc35ecb76cc867700f885087c22abeccc8840a00adfeda0c36b1cf32a0b"
    sha256 cellar: :any,                 monterey:       "af427a27e940353797d88a3b3224a43ad15ad51681494902dad975d5c5270d27"
    sha256 cellar: :any,                 big_sur:        "12d797bfc9b2a1414787aa3028c1704a5b6f1f000b80ed5e4cd200029f10f160"
    sha256 cellar: :any,                 catalina:       "d6770fea6a2589b7641fbeda183ff58835ae463cbbab3178096654b36a99b232"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b3fbb4b5c878b6566d343983213d2f21df250d77193d207637942d457bb8e049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cee5823d550698b94dc7e494af8b5f8a83acebec701264a4c20dec2d828c2240"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "sdl12-compat"

  # Fix build with clang; last release was in 2006
  patch :DATA

  def install
    # AM_C_PROTOTYPES was removed in automake 1.12, as it's only needed for
    # pre-ANSI compilers
    inreplace "configure.in", "AM_C_PROTOTYPES", ""
    inreplace "autogen.sh", "libtoolize", "glibtoolize"

    system "sh", "autogen.sh",
                 "--disable-platform", # Causes undefined symbols
                 "--disable-ctrl",     # No need to run these during configuration
                 "--disable-examples",
                 "--disable-sdltest",
                 *std_configure_args
    system "make", "install"
  end
end

__END__
diff --git a/include/agg_renderer_outline_aa.h b/include/agg_renderer_outline_aa.h
index ce25a2e..9a12d35 100644
--- a/include/agg_renderer_outline_aa.h
+++ b/include/agg_renderer_outline_aa.h
@@ -1375,7 +1375,7 @@ namespace agg
         //---------------------------------------------------------------------
         void profile(const line_profile_aa& prof) { m_profile = &prof; }
         const line_profile_aa& profile() const { return *m_profile; }
-        line_profile_aa& profile() { return *m_profile; }
+        const line_profile_aa& profile() { return *m_profile; }

         //---------------------------------------------------------------------
         int subpixel_width() const { return m_profile->subpixel_width(); }
