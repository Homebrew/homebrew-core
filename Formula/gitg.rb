class Gitg < Formula
  desc "GNOME GUI client to view git repositories"
  homepage "https://wiki.gnome.org/Apps/Gitg"
  url "https://download.gnome.org/sources/gitg/3.20/gitg-3.20.1.tar.xz"
  sha256 "104420bcdd765fa2196a7b146ba1e0fa82a5686ed5ba9af40e31e88e601aa585"

  bottle do
    sha256 "97d3ba5dba74be435381bdcf8813a81d6ae52c8bdbb66fc903045f3cf08d99ad" => :el_capitan
    sha256 "105441904cd1dcd3fad0d3614b0da321a43accc73e1b61e08693d1d31a02d2f3" => :yosemite
    sha256 "77ad5922dcd60467be6bcd6323f682e23a38f22a912f43cc35d712677ba7efb2" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "intltool" => :build
  depends_on "webkitgtk"
  depends_on "gtksourceview3"
  depends_on "gobject-introspection"
  depends_on "libgit2-glib"
  depends_on "gsettings-desktop-schemas"
  depends_on "libgee"
  depends_on "json-glib"
  depends_on "libsecret"
  depends_on "libpeas"
  depends_on "gtkspell3"
  depends_on "hicolor-icon-theme"
  depends_on "gnome-icon-theme"
  depends_on :python3 => :optional
  depends_on "pygobject3" => "with-python3" if build.with?("python3")

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # test executable
    assert_match version.to_s, shell_output("#{bin}/gitg --version")
    # test API
    (testpath/"test.c").write <<-EOS.undent
      #include <libgitg/libgitg.h>

      int main(int argc, char *argv[]) {
        GType gtype = gitg_stage_status_file_get_type();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gobject_introspection = Formula["gobject-introspection"]
    gtkx3 = Formula["gtk+3"]
    harfbuzz = Formula["harfbuzz"]
    libepoxy = Formula["libepoxy"]
    libffi = Formula["libffi"]
    libgee = Formula["libgee"]
    libgit2 = Formula["libgit2"]
    libgit2_glib = Formula["libgit2-glib"]
    libpng = Formula["libpng"]
    libsoup = Formula["libsoup"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    webkitgtk = Formula["webkitgtk"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gobject_introspection.opt_include}/gobject-introspection-1.0
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/libgitg-1.0
      -I#{libepoxy.opt_include}
      -I#{libgee.opt_include}/gee-0.8
      -I#{libffi.opt_lib}/libffi-3.0.13/include
      -I#{libgit2.opt_include}
      -I#{libgit2_glib.opt_include}/libgit2-glib-1.0
      -I#{libpng.opt_include}/libpng16
      -I#{libsoup.opt_include}/libsoup-2.4
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -I#{webkitgtk.opt_include}/webkitgtk-4.0
      -DGIT_SSH=1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gobject_introspection.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{libgee.opt_lib}
      -L#{libgit2.opt_lib}
      -L#{libgit2_glib.opt_lib}
      -L#{libsoup.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -L#{webkitgtk.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lgirepository-1.0
      -lgit2
      -lgit2-glib-1.0
      -lgitg-1.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lgthread-2.0
      -lgtk-3
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
