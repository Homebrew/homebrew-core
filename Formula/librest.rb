class Librest < Formula
  desc "Library to access RESTful web services"
  homepage "https://wiki.gnome.org/Projects/Librest"
  url "https://download.gnome.org/sources/rest/0.8/rest-0.8.1.tar.xz"
  sha256 "0513aad38e5d3cedd4ae3c551634e3be1b9baaa79775e53b2dba9456f15b01c9"
  revision 3

  bottle do
    sha256                               arm64_big_sur: "a565482a9685164d288df713142f23b91dda71fc9c694ea0c613c64320e4aa0a"
    sha256                               big_sur:       "366b341df1c40a648f2847b5f1c13efccfaeb4c3c9610c30fe7e5b3087d07186"
    sha256                               catalina:      "fb2e698cdf400c3f413a707132acd9b55139e2aa26da2f405f5eaebeace6573b"
    sha256                               mojave:        "dbaf452ac76dbc63e161ffc086aac7f6409614ca573c20fe02bd2e87d473e5b2"
    sha256                               high_sierra:   "5ab2748f8103ff622b6615f6427f21c7f9313b227824bd91429aa6f4c5c9c982"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be2f31807cddc48f6979d659856ed2fe5e1d641547e0dca5b8082575bee55952"
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
