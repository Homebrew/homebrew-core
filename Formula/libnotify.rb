class Libnotify < Formula
  desc "Library that sends desktop notifications to a notification daemon"
  homepage "https://gitlab.gnome.org/GNOME/libnotify"
  url "https://download.gnome.org/sources/libnotify/0.7/libnotify-0.7.12.tar.xz"
  sha256 "744b2b37508135f8261b755a9debe6e09add421adc75bde930f6e198b70ab46e"
  license "LGPL-2.1-or-later"

  # libnotify uses GNOME's "even-numbered minor is stable" version scheme but
  # we've been using a development version 0.7.x for many years, so we have to
  # match development versions until we're on a stable release.
  livecheck do
    url :stable
    regex(/libnotify-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "ea60a07fc234bbb4d539155e23eb4da86ef7c81daade5d5406bea970d30b6d29"
    sha256 cellar: :any, arm64_big_sur:  "bcf4130e904359d024eb488e5c6d81514581598443696ca7b1c28813f1f31e1e"
    sha256 cellar: :any, monterey:       "637d7e3ac38bca6844bf62f7ce0ef751ad1307278ee20743d70a79361ba7cb64"
    sha256 cellar: :any, big_sur:        "c7b404583a5ef078e81d033e6f16a6dbabf18557317fc4de18438ebda4ebe4cd"
    sha256 cellar: :any, catalina:       "d9b5374f6235992cdebe1d6cda5cb4a8fb3cfaee1470650d293d15b70978e171"
    sha256               x86_64_linux:   "ce619aca93b1bf507b2d3bfa58877f69140e5208a985f20191738bc330b69a66"
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
