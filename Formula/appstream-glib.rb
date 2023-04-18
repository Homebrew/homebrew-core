class AppstreamGlib < Formula
  desc "Helper library for reading and writing AppStream metadata"
  homepage "https://github.com/hughsie/appstream-glib"
  url "https://github.com/hughsie/appstream-glib/archive/appstream_glib_0_8_2.tar.gz"
  sha256 "83907d3b2c13029c72dfd11191762ef19f4031ac05c758297914cf0eb04bc641"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "c3f6d2c0984122b0713f4feb1602dbef56ff7cb387845f743e9eb141f27bcba2"
    sha256 cellar: :any, arm64_monterey: "90068630f6442eb177f80f7b724df77cf7bca37ab06d6b23f60e0473589c4e4f"
    sha256 cellar: :any, arm64_big_sur:  "44cf000fc5d424c0381ccfde90746356a135554a5fd8f9c7d5c6f1122f0cba2a"
    sha256 cellar: :any, ventura:        "791389da6a2ba026ad09b35a28d7dce14c57eb6d267ed3bf71aca3c0dd2dd618"
    sha256 cellar: :any, monterey:       "1f0c23d95b641c365c5ae51c9243c4e0c4b7eb3241c5a0fb826329a99fa76e4c"
    sha256 cellar: :any, big_sur:        "51567bf93b2dbd9aabb0dd044f7a05ece05a93f1e5b126e204f21d78a34d1e42"
    sha256               x86_64_linux:   "33cb7d8c477932888efedeb104d6b769963962b29c89ac9dbccbb067b7371ff6"
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

  uses_from_macos "gperf" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "util-linux"
  end

  # see https://github.com/hughsie/appstream-glib/issues/258
  patch :DATA

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "meson", *std_meson_args, "build", "-Dbuilder=false", "-Drpm=false", "-Ddep11=false", "-Dstemmer=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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
