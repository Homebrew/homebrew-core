class Gtksourceview4 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/4.4/gtksourceview-4.4.0.tar.xz"
  sha256 "9ddb914aef70a29a66acd93b4f762d5681202e44094d2d6370e51c9e389e689a"
  revision 1

  bottle do
    sha256 "13e996ab7ea8b4e2268f768b813f1815c0db7b7e008003b9f7f56929103769df" => :catalina
    sha256 "d0c76f227d0754e6a98d8842c4019bdbf7cc483cc7f4ea70f0e546221e29b52d" => :mojave
    sha256 "80489123e8993fb5149f920ad5182a1bdd1f6b4ff68f78ccf7f0adfd539d2347" => :high_sierra
    sha256 "795f7291d8baadba01c0a61b843177a4760bbab82c81b26058d1665c64657454" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gtk+3"

  # submitted upstream as https://gitlab.gnome.org/GNOME/gtksourceview/merge_requests/61
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      -Dgir=true
      -Dvapi=true
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtksourceview/gtksource.h>

      int main(int argc, char *argv[]) {
        gchar *text = gtk_source_utils_unescape_search_text("hello world");
        return 0;
      }
    EOS
    ENV.libxml2
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx3 = Formula["gtk+3"]
    harfbuzz = Formula["harfbuzz"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/gtksourceview-4
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-3
      -lgtksourceview-4.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/gtksourceview/meson.build b/gtksourceview/meson.build
index 14603ffe..82a28d2b 100644
--- a/gtksourceview/meson.build
+++ b/gtksourceview/meson.build
@@ -248,6 +248,7 @@ if cc.get_id() == 'msvc'
 else
   gtksource_lib = shared_library(package_string, gtksource_res,
                   version: lib_version,
+          darwin_versions: lib_osx_version,
       include_directories: gtksourceview_include_dirs,
              dependencies: gtksource_deps,
                link_whole: gtksource_libs,
diff --git a/meson.build b/meson.build
index 78c2fc59..ef3d5d6b 100644
--- a/meson.build
+++ b/meson.build
@@ -21,10 +21,14 @@ version_micro = version_arr[2].to_int()
 api_version = '4'

 lib_version = '0.0.0'
-lib_version_arr = version.split('.')
-lib_version_major = version_arr[0].to_int()
-lib_version_minor = version_arr[1].to_int()
-lib_version_micro = version_arr[2].to_int()
+lib_version_arr = lib_version.split('.')
+lib_version_major = lib_version_arr[0].to_int()
+lib_version_minor = lib_version_arr[1].to_int()
+lib_version_micro = lib_version_arr[2].to_int()
+
+osx_current = lib_version_minor + 1
+lib_osx_version = [osx_current, '@0@.@1@'.format(osx_current, lib_version_micro)]
+

 package_name = meson.project_name()
 package_string = '@0@-@1@'.format(package_name, api_version)
