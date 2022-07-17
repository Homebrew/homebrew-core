class Libnotify < Formula
  desc "Library that sends desktop notifications to a notification daemon"
  homepage "https://gitlab.gnome.org/GNOME/libnotify"
  url "https://download.gnome.org/sources/libnotify/0.8/libnotify-0.8.1.tar.xz"
  sha256 "d033e6d4d6ccbf46a436c31628a4b661b36dca1f5d4174fe0173e274f4e62557"
  license "LGPL-2.1-or-later"

  # libnotify uses GNOME's "even-numbered minor is stable" version scheme but
  # we've been using a development version 0.7.x for many years, so we have to
  # match development versions until we're on a stable release.
  livecheck do
    url :stable
    regex(/libnotify-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "207a1e2643da8fa77241eefe767af2dff4567a63f21290948f9c06e227cb96d0"
    sha256 cellar: :any, arm64_big_sur:  "0e4de0591aa4c944aa0dd2178b641b29289a045852e27064622247d27b734d1a"
    sha256 cellar: :any, monterey:       "f7b0607b025c358990f4b62e9bfbd8bed99a04ecc13ff81842b1e7bf2abc7813"
    sha256 cellar: :any, big_sur:        "2e158667c58c9ec87a1585abd5cbb60e54b67774ed3e675fed4913912efb2565"
    sha256 cellar: :any, catalina:       "f5152979e2d47a30b333d0e1ca433461abb03c43247dbbbbfff9d190f3c03e18"
    sha256               x86_64_linux:   "4aff67e97e2af789f1e1316ad0c75481888a506d8a01aad2f4c5a1c2fc90fe84"
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
      system "meson", *std_meson_args, "-Dtests=false", ".."
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
