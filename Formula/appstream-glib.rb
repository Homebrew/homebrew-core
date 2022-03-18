class AppstreamGlib < Formula
  desc "Helper library for reading and writing AppStream metadata"
  homepage "https://github.com/hughsie/appstream-glib"
  url "https://github.com/hughsie/appstream-glib/archive/appstream_glib_0_7_18.tar.gz"
  sha256 "73b8c10273c4cdd8f6de03c2524fedad64e34ccae08ee847dba804bb15461f6e"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "7389aa5d3dc05124ddab77a39fcde0b5b44c74b4ef6bb283f652cfc1f1de5175"
    sha256 cellar: :any, monterey:      "53220b9e712d6a473fd09d9a82df67c7d7b93b9eb171978f0e8180055166ebb5"
    sha256 cellar: :any, big_sur:       "1aded5fd6345ce3337cea5141bded4945f481392bf8686532f211d8b5bb2a777"
    sha256 cellar: :any, catalina:      "2382482db7b4ef8f7b3682014498eb1e49ec626a88d9baa6e3bc71d9ad23c13b"
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "json-glib"
  depends_on "libarchive"
  depends_on "libsoup@2"
  depends_on "util-linux"

  # see https://github.com/hughsie/appstream-glib/issues/258
  patch :DATA

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    mkdir "build" do
      system "meson", *std_meson_args, "-Dbuilder=false", "-Drpm=false", "-Ddep11=false", "-Dstemmer=false", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <appstream-glib.h>

      int main(int argc, char *argv[]) {
        AsScreenshot *screen_shot = as_screenshot_new();
        g_assert_nonnull(screen_shot);
        return 0;
      }
    EOS
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libappstream-glib
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lappstream-glib
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
    system "#{bin}/appstream-util", "--help"
  end
end

__END__
diff --git a/libappstream-glib/meson.build b/libappstream-glib/meson.build
index 5f726b0..7d29ac8 100644
--- a/libappstream-glib/meson.build
+++ b/libappstream-glib/meson.build
@@ -136,7 +136,6 @@ asglib = shared_library(
   dependencies : deps,
   c_args : cargs,
   include_directories : include_directories('..'),
-  link_args : vflag,
   link_depends : mapfile,
   install : true,
 )
