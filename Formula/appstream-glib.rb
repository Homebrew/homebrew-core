class AppstreamGlib < Formula
  desc "Helper library for reading and writing AppStream metadata"
  homepage "https://github.com/hughsie/appstream-glib"
  url "https://github.com/hughsie/appstream-glib/archive/appstream_glib_0_7_16.tar.gz"
  sha256 "71e19fff681eb74795dbcb428f1dc9cf28bf9207378b6c1c9ce55375f0f22b14"

  bottle do
    cellar :any
    sha256 "bfd14ae728275b151a4cc79c3e6754ab974ef732118f43e47f7a3a4dc29c28ac" => :catalina
    sha256 "567caa84b4a6d0ffcffed0b0fdb78bbb0d04529e49acd34753c7f0181439e7f8" => :mojave
    sha256 "4b2514928e260215f3a6258167e0544f587f73a9ab3f202bebafc4c66765752e" => :high_sierra
    sha256 "d11c16c5b3300d4933b83af64cf68ecc4ee77a3f93dd6b8b4c5c459b37d2cc79" => :sierra
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
  depends_on "libsoup"
  depends_on "util-linux"

  # see https://github.com/hughsie/appstream-glib/issues/258
  patch :DATA

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Dbuilder=false", "-Drpm=false", "-Ddep11=false", "-Dstemmer=false", ".."
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
      -lintl
    ]
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
