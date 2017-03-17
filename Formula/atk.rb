class Atk < Formula
  desc "GNOME accessibility toolkit"
  homepage "https://library.gnome.org/devel/atk/"
  url "https://download.gnome.org/sources/atk/2.24/atk-2.24.0.tar.xz"
  sha256 "bb2daa9a808c73a7a79d2983f333e0ba74be42fc51e3ba1faf2551a636487a49"

  bottle do
    sha256 "0223438a41f539e2c9a9d1b8b8f68d8a67c5ac9dbaae32b7a117da68f8947828" => :sierra
    sha256 "a065750a4ea385f6504b111f6f538b9bd64b3526bb65a72f705276ebecefbb7d" => :el_capitan
    sha256 "5f9a612ac3616d720a14f148f19e0a4d3a2259d58fc18edc548443635bc28f48" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <atk/atk.h>

      int main(int argc, char *argv[]) {
        const gchar *version = atk_get_version();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/atk-1.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -latk-1.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
