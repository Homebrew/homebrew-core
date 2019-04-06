class Libnotify < Formula
  desc "Library that sends desktop notifications to a notification daemon"
  homepage "https://developer.gnome.org/libnotify"
  url "https://download.gnome.org/sources/libnotify/0.7/libnotify-0.7.8.tar.xz"
  sha256 "69209e0b663776a00c7b6c0e560302a8dbf66b2551d55616304f240bba66e18c"

  bottle do
    sha256 "d45147d1218ee584b2d67ce23e6bd60553a83424c3c0a69cd8a14f6e238a398c" => :mojave
    sha256 "f88f445a6b5719c695aa606da3050d3e24ddc1c7a586f6541186025551d273e6" => :high_sierra
    sha256 "09166e1efa743eed930b7aca87b084de644735f8af17133bf697e24b70f8018f" => :sierra
    sha256 "0139ddf8047c88ee6c29abfa8a112dce897150d54a0d83b9d2892d5033829a6d" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gdk-pixbuf"

  def install
    # the latest build does not include configure so we need to
    # generate it from configure.ac.
    # Upstream issue at https://gitlab.gnome.org/GNOME/libnotify/issues/5
    mkdir_p "m4"
    system "gtkdocize", "--copy"
    system "autoreconf", "-i"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-tests",
                          "--enable-introspection"
    system "make", "install"
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
