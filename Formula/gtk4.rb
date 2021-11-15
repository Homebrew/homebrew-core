class Gtk4 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk/4.4/gtk-4.4.1.tar.xz"
  sha256 "0faada983dc6b0bc409cb34c1713c1f3267e67c093f86b1e3b17db6100a3ddf4"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/gtk[._-](4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "21cfa9ea0cb1d4a894aa2055b178f204e814b9eaa89533ca00272c268b534a94"
    sha256 arm64_big_sur:  "ebcdde6bcc46923c3846f8649f2985104841a595a80b74126594ea86d34a0213"
    sha256 monterey:       "6fef029e3839d13d2a6813f9e34b84eb36addf8885113e6a2cbf7ffee447632a"
    sha256 big_sur:        "92dde4ba678417f9832635306119890d880980fdfee1581559e2f41b2374603b"
    sha256 catalina:       "ed2681c43dfbe6ddb05539a27330868d96ade6b3988995b6024af59113d0d495"
    sha256 x86_64_linux:   "f16c2c380add2a64b162f8329673749e6346d7a56960f4a43aec83760d5fb5a1"
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "sassc" => :build
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
  depends_on "hicolor-icon-theme"
  depends_on "libepoxy"
  depends_on "pango"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "cups"

  on_linux do
    depends_on "libxkbcommon"
    depends_on "libxcursor"
  end

  # This patch (embedded below) backports the upstream fix made by PR !4008
  # (https://gitlab.gnome.org/GNOME/gtk/-/merge_requests/4008) to 4.4.1. It was
  # unfortunately missed when the changes for 4.4.1 were reviewed but Gtk apps
  # will crash on Apple Silicon Macs without it. The fix should be included in
  # 4.6.0 when it is released, so this patch can be removed at that point.
  patch :DATA

  def install
    args = std_meson_args + %w[
      -Dgtk_doc=false
      -Dman-pages=true
      -Dintrospection=enabled
      -Dbuild-examples=false
      -Dbuild-tests=false
      -Dmedia-gstreamer=disabled
    ]

    if OS.mac?
      args << "-Dx11-backend=false"
      args << "-Dmacos-backend=true"
      args << "-Dprint-cups=disabled" if MacOS.version <= :mojave
    end

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # Disable asserts and cast checks explicitly
    ENV.append "CPPFLAGS", "-DG_DISABLE_ASSERT -DG_DISABLE_CAST_CHECKS"

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system bin/"gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "#{Formula["glib"].opt_bin}/gio-querymodules", "#{HOMEBREW_PREFIX}/lib/gtk-4.0/4.0.0/printbackends"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        gtk_disable_setlocale();
        return 0;
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs gtk4").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
    # include a version check for the pkg-config files
    assert_match version.to_s, shell_output("cat #{lib}/pkgconfig/gtk4.pc").strip
  end
end
__END__
diff --git a/gdk/macos/gdkmacosglcontext.c b/gdk/macos/gdkmacosglcontext.c
index cc0b5fa..9ab268a 100644
--- a/gdk/macos/gdkmacosglcontext.c
+++ b/gdk/macos/gdkmacosglcontext.c
@@ -227,8 +227,8 @@ gdk_macos_gl_context_real_realize (GdkGLContext  *context,
 
   swapRect[0] = 0;
   swapRect[1] = 0;
-  swapRect[2] = surface->width;
-  swapRect[3] = surface->height;
+  swapRect[2] = surface ? surface->width : 0;
+  swapRect[3] = surface ? surface->height : 0;
 
   CGLSetParameter (cgl_context, kCGLCPSwapRectangle, swapRect);
   CGLSetParameter (cgl_context, kCGLCPSwapInterval, &sync_to_framerate);
