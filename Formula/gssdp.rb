class Gssdp < Formula
  desc "GUPnP library for resource discovery and announcement over SSDP"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gssdp/1.0/gssdp-1.0.0.tar.xz"
  sha256 "1b1df551df5ff4d856d064f785753a2eabccb89c358bae9f23f4b88c5c984173"

  bottle do
    sha256 "597b60408b18902393e99b75f1118c9af9eed8d451a840a2d790da61ff993233" => :sierra
    sha256 "7c30203fdafe6e38b319edcf20c6e284e249fe33d10731b9a37d498bbd30ae1f" => :el_capitan
    sha256 "f0ba1b56831a64c25549c694c70e755a4e51dede696fa2c82a3a3b6924bc5803" => :yosemite
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
