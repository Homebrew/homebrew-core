class Librest < Formula
  desc "Library to access RESTful web services"
  homepage "https://wiki.gnome.org/Projects/Librest"
  url "https://download.gnome.org/sources/rest/0.8/rest-0.8.1.tar.xz"
  sha256 "0513aad38e5d3cedd4ae3c551634e3be1b9baaa79775e53b2dba9456f15b01c9"
  revision 1

  bottle do
    sha256 "395cfe3524a16bb5f6b11501b5abaa58091498af73cf6fa44b900e16f8cfd0e4" => :mojave
    sha256 "677a14fd8dde39e068cc8bb4fe771619a13bdde7e92903756ecb056b79ee69e7" => :high_sierra
    sha256 "79fed6ba59358147b84ee7f793df20542e21c1537f3b7a1ff0572296d5503e20" => :sierra
    sha256 "5333e6b41033827ec7db0fedb3510fe4ab442cd53180c5cd1ebc613b4e1b3bfc" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsoup"

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
    (testpath/"test.c").write <<~EOS
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
