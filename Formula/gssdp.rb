class Gssdp < Formula
  desc "GUPnP library for resource discovery and announcement over SSDP"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gssdp/1.0/gssdp-1.0.3.tar.xz"
  sha256 "211387a62bc1d99821dd0333d873a781320287f5436f91e58b2ca145b378be41"

  bottle do
    cellar :any
    sha256 "0b33c442e3ac602474980603f72ae51cd003e338d89aaedebbdc858dda2a6b93" => :mojave
    sha256 "7c745644a57ff5a9d80d7422830770aad3c80aabef6009a4db107612b97d2536" => :high_sierra
    sha256 "fd8130caac892fab33a2abf2db7f7089455d700fa5454d36820d54781adae7be" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libgssdp/gssdp.h>

      int main(int argc, char *argv[]) {
        GType type = gssdp_client_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gssdp-1.0
      -D_REENTRANT
      -L#{lib}
      -lgssdp-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
