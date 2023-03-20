class Libnotify < Formula
  desc "Library that sends desktop notifications to a notification daemon"
  homepage "https://gitlab.gnome.org/GNOME/libnotify"
  url "https://download.gnome.org/sources/libnotify/0.8/libnotify-0.8.2.tar.xz"
  sha256 "c5f4ed3d1f86e5b118c76415aacb861873ed3e6f0c6b3181b828cf584fc5c616"
  license "LGPL-2.1-or-later"

  # libnotify uses GNOME's "even-numbered minor is stable" version scheme but
  # we've been using a development version 0.7.x for many years, so we have to
  # match development versions until we're on a stable release.
  livecheck do
    url :stable
    regex(/libnotify-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "da8416027843b0efad2701b512782aa02a5e58dddbfd35ac3d0f6482ce1f70a8"
    sha256 cellar: :any, arm64_monterey: "1e65844fef7f12da5d787fd4743efb679d75426be9cd29c95e90acd1cf796eae"
    sha256 cellar: :any, arm64_big_sur:  "d6791d4b6740a03295e475b5c5c7aab55e1f8a43870bdc8780cbba2d09da54dd"
    sha256 cellar: :any, ventura:        "f16ba567c4a40c0907c1a810f541588315656322436947b6d888ad9195519653"
    sha256 cellar: :any, monterey:       "2960d4614787e4e103e3045e394da59512da87c16ec7656fff55b62e9a726fb2"
    sha256 cellar: :any, big_sur:        "e0dc28e32a60b3c1c460fca8f68ec003006803166ca223ce126ea38575c08611"
    sha256               x86_64_linux:   "c8a4030a410cfadc538b0c4b5913d00177ba5a6445ba8917f5e58827b95bf01b"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gdk-pixbuf"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    mkdir "build" do
      system "meson", *std_meson_args, "-Dgtk_doc=false", "-Dman=false", "-Dtests=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libnotify/notify.h>

      int main(int argc, char *argv[]) {
        g_assert_true(notify_init("testapp"));
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{lib}
      -lnotify
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
