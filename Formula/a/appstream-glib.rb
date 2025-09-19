class AppstreamGlib < Formula
  desc "Helper library for reading and writing AppStream metadata"
  homepage "https://github.com/hughsie/appstream-glib"
  url "https://github.com/hughsie/appstream-glib/archive/refs/tags/appstream_glib_0_8_3.tar.gz"
  sha256 "15ad7690b0132d883bd066699a7b55f6cef4c0f266d18d781ce5d8112fb4ee63"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:    "2587f394775fa2f8b69be4db40c9bbe66d5b4d961803ac90e8f7b0e67c171259"
    sha256 cellar: :any, arm64_sequoia:  "8b7403b1054de2416fa93563425321346b3f19e0828dc570eda83d6275892c69"
    sha256 cellar: :any, arm64_sonoma:   "436c07f995a7eebb35d00956d96b5a3a7839fe406ad2ecfcb870ba47c2fe14cf"
    sha256 cellar: :any, arm64_ventura:  "5fc017681fbd7c6900cc1a81412d922d681266fc53842b81b14b76975a4ec76e"
    sha256 cellar: :any, arm64_monterey: "ec5bcbd5802db3070ef6f9e2401608d45e1a0b26820342dab42b7b123861298e"
    sha256 cellar: :any, sonoma:         "9ee04a0e10295134da81fe789ff2acac90c3d64ffb2d33a5e6700a4bdd5f6a6c"
    sha256 cellar: :any, ventura:        "ea40ca29ab320034cc36833efd33aa20c8ebe128fb013bfa3e2a3cef4e3eecc6"
    sha256 cellar: :any, monterey:       "648ab1fde37e8da156d657d26c5f9d5e2b2d18acf36896c7cf9508f11819ab25"
    sha256               arm64_linux:    "a8eb70a5bc4dcbbe274a1ad1ce81f8aa99738e8db59996f6e6c10c6c3294eb0f"
    sha256               x86_64_linux:   "e3817d099c3f3d7bcdb0aec2920ff5b92e76454398d4efda5acb72c6d2ac4a1f"
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "json-glib"
  depends_on "libarchive"

  uses_from_macos "gperf" => :build
  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "util-linux"
  end

  # see https://github.com/hughsie/appstream-glib/issues/258
  patch :DATA

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "meson", "setup", "build", "-Dbuilder=false", "-Drpm=false", "-Ddep11=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <appstream-glib.h>

      int main(int argc, char *argv[]) {
        AsScreenshot *screen_shot = as_screenshot_new();
        g_assert_nonnull(screen_shot);
        return 0;
      }
    C

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libarchive"].opt_lib/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs appstream-glib").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
    system bin/"appstream-util", "--help"
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
