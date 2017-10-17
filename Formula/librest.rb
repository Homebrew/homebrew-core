class Librest < Formula
  desc "Library to access RESTful web services"
  homepage "https://wiki.gnome.org/Projects/Librest"
  url "https://download.gnome.org/sources/rest/0.8/rest-0.8.1.tar.xz"
  sha256 "0513aad38e5d3cedd4ae3c551634e3be1b9baaa79775e53b2dba9456f15b01c9"

  bottle do
    sha256 "9051b6736cc74cc7cf4869d80be7573b13361f33464f89eb88bccae86d22c1e9" => :high_sierra
    sha256 "a799cab80624c9a4ad497725f13889608fee9f22030a85add84bd246a79a1693" => :sierra
    sha256 "a2499387aa86673e5c7a04c88df26ca47f7b3498687c40b32dbcf14619084899" => :el_capitan
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
