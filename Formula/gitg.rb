class Gitg < Formula
  desc "GNOME GUI client to view git repositories"
  homepage "https://wiki.gnome.org/Apps/Gitg"
  url "https://download.gnome.org/sources/gitg/3.30/gitg-3.30.0.tar.xz"
  sha256 "a710ae86fbd62124560ebeae0299f158662f7b31ab646c4dd09d8a03c8570a97"

  bottle do
    sha256 "0dba644784645a1a977233da73d97a4299ff08fed57e9745e74f6e5fa27e5617" => :mojave
    sha256 "351b3dfa3ebb00def0bb4543f273cf2496fc9578fe1bd6d314a24d51e3b7255a" => :high_sierra
    sha256 "66bf910fe6d96457982e0fad397a3b17cd2e2e7368da92c78e2bada3c519c52a" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "gtksourceview3"
  depends_on "gtkspell3"
  depends_on "hicolor-icon-theme"
  depends_on "libgee"
  depends_on "libgit2"
  depends_on "libgit2-glib"
  depends_on "libpeas"
  depends_on "libsecret"
  depends_on "libsoup"

  # reported upstream: https://gitlab.gnome.org/GNOME/gitg/issues/145
  patch :DATA

  def install
    ENV["DESTDIR"] = "/"

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Dpython=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # test executable
    assert_match version.to_s, shell_output("#{bin}/gitg --version")
    # test API
    (testpath/"test.c").write <<~EOS
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
      -I#{gobject_introspection.opt_include}/gobject-introspection-1.0
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/libgitg-1.0
      -I#{libepoxy.opt_include}
      -I#{libgee.opt_include}/gee-0.8
      -I#{libffi.opt_lib}/libffi-3.0.13/include
      -I#{libgit2}/include
      -I#{libgit2_glib.opt_include}/libgit2-glib-1.0
      -I#{libpng.opt_include}/libpng16
      -I#{libsoup.opt_include}/libsoup-2.4
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
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

__END__
diff --git a/libgitg/meson.build b/libgitg/meson.build
index 793f2c2..fbc42da 100644
--- a/libgitg/meson.build
+++ b/libgitg/meson.build
@@ -114,14 +114,13 @@ if gdk_targets.contains('quartz')
   sources += files('gitg-platform-support-osx.c')
   gio_system_pkg = 'gio-unix-2.0'
   deps += [
-    dependency(gio_system_pkg),
-    find_library('objc')
+    dependency(gio_system_pkg)
   ]
   cflags += '-xobjective-c'

   test_ldflags += [
-    '-framework Foundation',
-    '-framework AppKit'
+    '-Wl,-framework', '-Wl,Foundation',
+    '-Wl,-framework', '-Wl,AppKit'
   ]
 elif gdk_targets.contains('win32')
   sources += files('gitg-platform-support-win32.c')
@@ -134,9 +133,7 @@ else
 endif

 foreach test_ldflag: test_ldflags
-  if cc.has_argument(test_ldflag)
     ldflags += test_ldflag
-  endif
 endforeach

 libgitg = shared_library(
diff --git a/meson.build b/meson.build
index 0790c5e..61c7417 100644
--- a/meson.build
+++ b/meson.build
@@ -79,11 +79,9 @@ endif

 if gitg_debug
   test_cflags = [
-    '-Werror=format=2',
     '-Werror=implicit-function-declaration',
     '-Werror=init-self',
     '-Werror=missing-include-dirs',
-    '-Werror=missing-prototypes',
     '-Werror=pointer-arith',
     '-Werror=return-type',
     '-Wmissing-declarations',
diff --git a/plugins/diff/meson.build b/plugins/diff/meson.build
index efc0d5d..d92c558 100644
--- a/plugins/diff/meson.build
+++ b/plugins/diff/meson.build
@@ -17,5 +17,6 @@ libdiff = shared_module(
   dependencies: plugin_deps,
   c_args: plugin_cflags,
   install: true,
-  install_dir: plugin_dir
+  install_dir: plugin_dir,
+  name_suffix: 'so'
 )
diff --git a/plugins/files/meson.build b/plugins/files/meson.build
index 74e34cc..f072fd3 100644
--- a/plugins/files/meson.build
+++ b/plugins/files/meson.build
@@ -24,5 +24,6 @@ libfiles = shared_module(
   dependencies: plugin_deps,
   c_args: plugin_cflags,
   install: true,
-  install_dir: plugin_dir
+  install_dir: plugin_dir,
+  name_suffix: 'so'
 )
