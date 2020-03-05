class Libnotify < Formula
  desc "Library that sends desktop notifications to a notification daemon"
  homepage "https://developer.gnome.org/libnotify"
  url "https://download.gnome.org/sources/libnotify/0.7/libnotify-0.7.9.tar.xz"
  sha256 "66c0517ed16df7af258e83208faaf5069727dfd66995c4bbc51c16954d674761"

  bottle do
    sha256 "b3d67293db66122b210e6ce6dcac62c2e71dbb881ab87a5e8bac3d4b16b4111f" => :catalina
    sha256 "49a2299522d7c86e46ac6c6a2e2dbeab7b20c2e18f84b61c9d4370fc38c0511a" => :mojave
    sha256 "d467b8388a30fe7bd2a327e0422c5316183ac161f45754b8709447cd74c35bb1" => :high_sierra
    sha256 "54dd14c50b6979b7924580431bad1cf61b81940a873fe7390974de9a7cb1cd24" => :sierra
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
      system "meson", "..", "--prefix=#{prefix}", "-Dtests=false"
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
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
