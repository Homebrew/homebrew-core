class Gssdp < Formula
  desc "GUPnP library for resource discovery and announcement over SSDP"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gssdp/1.0/gssdp-1.0.2.tar.xz"
  sha256 "a1e17c09c7e1a185b0bd84fd6ff3794045a3cd729b707c23e422ff66471535dc"

  bottle do
    sha256 "d29d7e15bd8ceae958e69a08b058ae9a9ccac273dee2182545d4371048efbb6e" => :sierra
    sha256 "32cb5ef5c518bc5d1812a34ebade6a82cc43f036f4a40fc77719dfcafe6dad02" => :el_capitan
    sha256 "540ceba3f55e06e642ab67d53dc84f94a4a55b4e0381f4d015f15991e102b255" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
