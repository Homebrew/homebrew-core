class Gssdp < Formula
  desc "GUPnP library for resource discovery and announcement over SSDP"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gssdp/1.0/gssdp-1.0.3.tar.xz"
  sha256 "211387a62bc1d99821dd0333d873a781320287f5436f91e58b2ca145b378be41"

  bottle do
    cellar :any
    sha256 "0ecc3cbb1b4f765a6057dcc1b4a295116dd809be648f4a476e7d2d98c3348f1c" => :mojave
    sha256 "c8ac9c7c755749b7a6ea9790efab2311c9fc3d62a1af62b719968f14a7c25b62" => :high_sierra
    sha256 "3786f067d3b19ce3021618aaf434fd325862f90d03b7fd5ac12f6f37f8715e42" => :sierra
    sha256 "7927b712f8f9570c0a7e21593786bd41edf0daf2e14b7998886af9a00a8c2ab0" => :el_capitan
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
