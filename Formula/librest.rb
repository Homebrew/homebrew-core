class Librest < Formula
  desc "Library to access RESTful web services"
  homepage "https://wiki.gnome.org/Projects/Librest"
  url "https://download.gnome.org/sources/rest/0.8/rest-0.8.0.tar.xz"
  sha256 "e7b89b200c1417073aef739e8a27ff2ab578056c27796ec74f5886a5e0dff647"

  bottle do
    sha256 "da794be6ebdfde460d0e447123c45672861198afa8d651dd77cebf3df20d0c4c" => :sierra
    sha256 "493c2bf876de213bce3ec5aa739c437a0b0384ac8f8f722a23ba7987d2604879" => :el_capitan
    sha256 "8b98b39acc982309f1d15c20466a6675185100fdf9a21da6ff30ed4cc32a9946" => :yosemite
    sha256 "d2e3fbb297d83bcf4064539968f5c070443786c187c803d264ad4a30d8454a35" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsoup"
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-gnome",
                          "--without-ca-certificates",
                          "--enable-introspection=yes"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdlib.h>
      #include <rest/rest-proxy.h>

      int main(int argc, char *argv[]) {
        RestProxy *proxy = rest_proxy_new("http://localhost", FALSE);

        g_object_unref(proxy);

        return EXIT_SUCCESS;
      }
    EOS
    glib = Formula["glib"]
    libsoup = Formula["libsoup"]
    flags = %W[
      -I#{libsoup.opt_include}/libsoup-2.4
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/rest-0.7
      -L#{libsoup.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lrest-0.7
      -lgobject-2.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
