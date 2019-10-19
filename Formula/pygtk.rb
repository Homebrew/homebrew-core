class Pygtk < Formula
  desc "GTK+ bindings for Python"
  homepage "http://www.pygtk.org/"
  url "https://download.gnome.org/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2"
  sha256 "cd1c1ea265bd63ff669e92a2d3c2a88eb26bcd9e5363e0f82c896e649f206912"
  revision 3

  bottle do
    cellar :any
    rebuild 2
    sha256 "12bab3d76587659b38e56867c9b359941803275716896e2936cd3e8029cf5f3f" => :catalina
    sha256 "87f89d246e3a779381ec2efdee7ee2b69fda464f38a59dd8e14304435d759419" => :mojave
    sha256 "969cef803e110b2767c6d3ade304b92d7f23a02ff7eb4030772b69b52df7c3b2" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "libglade"
  depends_on "py2cairo"
  depends_on "pygobject"

  # Allow building with recent Pango, where some symbols were removed
  patch :DATA

  def install
    ENV.append "CFLAGS", "-ObjC"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    # Fixing the pkgconfig file to find codegen, because it was moved from
    # pygtk to pygobject. But our pkgfiles point into the cellar and in the
    # pygtk-cellar there is no pygobject.
    inreplace lib/"pkgconfig/pygtk-2.0.pc", "codegendir=${datadir}/pygobject/2.0/codegen", "codegendir=#{HOMEBREW_PREFIX}/share/pygobject/2.0/codegen"
    inreplace bin/"pygtk-codegen-2.0", "exec_prefix=${prefix}", "exec_prefix=#{Formula["pygobject"].opt_prefix}"
  end

  test do
    (testpath/"codegen.def").write("(define-enum asdf)")
    system "#{bin}/pygtk-codegen-2.0", "codegen.def"
  end
end
__END__
diff -pur a/pango-types.defs b/pango-types.defs
--- a/pango-types.defs	2011-04-01 12:37:25.000000000 +0200
+++ b/pango-types.defs	2019-10-19 14:44:23.000000000 +0200
@@ -176,13 +176,6 @@
   (gtype-id "PANGO_TYPE_FONTSET")
 )

-(define-object FontsetSimple
-  (in-module "Pango")
-  (parent "PangoFontset")
-  (c-name "PangoFontsetSimple")
-  (gtype-id "PANGO_TYPE_FONTSET_SIMPLE")
-)
-
 (define-object Layout
   (in-module "Pango")
   (parent "GObject")
diff -pur a/pango.defs b/pango.defs
--- a/pango.defs	2011-04-01 12:37:25.000000000 +0200
+++ b/pango.defs	2019-10-19 14:40:13.000000000 +0200
@@ -1303,16 +1303,6 @@
   )
 )

-(define-method find_shaper
-  (of-object "PangoFont")
-  (c-name "pango_font_find_shaper")
-  (return-type "PangoEngineShape*")
-  (parameters
-    '("PangoLanguage*" "language")
-    '("guint32" "ch")
-  )
-)
-
 (define-method get_metrics
   (of-object "PangoFont")
   (c-name "pango_font_get_metrics")
@@ -1391,15 +1381,6 @@
   )
 )

-(define-virtual find_shaper
-  (of-object "PangoFont")
-  (return-type "PangoEngineShape*")
-  (parameters
-    '("PangoLanguage*" "lang")
-    '("guint32" "ch")
-  )
-)
-
 (define-virtual get_glyph_extents
   (of-object "PangoFont")
   (return-type "none")
