class AppstreamGlib < Formula
  desc "Helper library for reading and writing AppStream metadata"
  homepage "https://github.com/hughsie/appstream-glib"
  url "https://github.com/hughsie/appstream-glib/archive/appstream_glib_0_8_1.tar.gz"
  sha256 "b0a4ab7fb9ce98805930a5f1fe5b54452cbac63e953ef5022b410d380a2fefc8"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "e89effd859f2dfc558e32b29897f1fd57887b1b944c5a561797317f13e46c53c"
    sha256 cellar: :any, arm64_monterey: "92eacc99e95ac535ab156128e6580614155752b44b238b8f3554dd3a029efe1f"
    sha256 cellar: :any, arm64_big_sur:  "1417693c475e34dc3ee212d6ba7a97941aef25fa04c7739215b30b633e885a98"
    sha256 cellar: :any, ventura:        "1799f373a3f6551034441e6f5f317c5f556b2ebe0455bd2bc82ee05fcfa39e3c"
    sha256 cellar: :any, monterey:       "b6cc141d0ea886375b91af04a25c7fcbcb760235ec09fed5da27f2115788604a"
    sha256 cellar: :any, big_sur:        "5dae28e5a4cefbf03c60c5dfd9b29ef38ddd500dab3df2a8abb0308dd940815f"
    sha256 cellar: :any, catalina:       "ce622e678145aee0f5125727b0ddd3d710327a427490d8d05fa5d351e01b24fa"
    sha256               x86_64_linux:   "fd872f77e5aa1bbf1410271f19503f9159de058bfa30b2380aface9577cfcd88"
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
