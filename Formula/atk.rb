class Atk < Formula
  desc "GNOME accessibility toolkit"
  homepage "https://library.gnome.org/devel/atk/"
  url "https://download.gnome.org/sources/atk/2.28/atk-2.28.0.tar.xz"
  sha256 "2016b61b8ed54da46e8dcbd2c4b0f6cd9c668f229eb966821d5680926a91ba3f"

  bottle do
    sha256 "78a16b44fa92e0108423d4257e465ab4bf51f98213c7cc3e42f4090b1fb81b87" => :high_sierra
    sha256 "35d0fd28fb37cbe1019d6ae5139e780cef85c9c5a5dd9eb1fc64b0b5b254e848" => :sierra
    sha256 "8648b56bb551d27ae162a01ccfced39877ee8735b0895a08f737328c93a74649" => :el_capitan
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
    (testpath/"test.c").write <<~EOS
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
