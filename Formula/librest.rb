class Librest < Formula
  desc "Library to access RESTful web services"
  homepage "https://wiki.gnome.org/Projects/Librest"
  url "https://download.gnome.org/sources/rest/0.8/rest-0.8.1.tar.xz"
  sha256 "0513aad38e5d3cedd4ae3c551634e3be1b9baaa79775e53b2dba9456f15b01c9"
  revision 4

  bottle do
    rebuild 1
    sha256                               arm64_ventura:  "5b9577e9c171c879a9fe98ed60239ac2997732b0d3d23be936ec4c8b51e660d7"
    sha256                               arm64_monterey: "b82cb89cd5181ce20e2bce9f9255bd7878a13d9badb6c0c8fe633be3c1fe748a"
    sha256                               arm64_big_sur:  "ce82e6e380a02285f90307b8609e63cba7dfa52a3d1fae7092296f49e67f624f"
    sha256                               ventura:        "0d09e17ff17368fce86679192c085e87cb17d48dc71e95cc27caa653b5ea614f"
    sha256                               monterey:       "fc839b0cce9619c5489fe51408792ada7ab2a5569419cd38569ca13fa6ef356b"
    sha256                               big_sur:        "83313f7234d69f6801104ba55c1b60933d8db57d8b8f818b336b8a498043b067"
    sha256                               catalina:       "7616a630b4f286a28c6520917353196f29e5ddbc488bf6880d14cb518271ff26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ea0c9d41ed04199de23e8cc5cc1b0dc8ea45e24f437b0b78dc823ce0dea0018"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsoup@2"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libsoup@2"].opt_lib/"pkgconfig"
    ENV.prepend_path "XDG_DATA_DIRS", Formula["libsoup@2"].opt_share
    ENV.prepend_path "XDG_DATA_DIRS", HOMEBREW_PREFIX/"share"

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
    libsoup = Formula["libsoup@2"]
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
