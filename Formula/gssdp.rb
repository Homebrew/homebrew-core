class Gssdp < Formula
  desc "GUPnP library for resource discovery and announcement over SSDP"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gssdp/0.14/gssdp-0.14.15.tar.xz"
  sha256 "084991de1fad8400e55d3ddd0ce8d07786fd7bfa36503f7089bd1f2ba5bda20c"

  bottle do
    sha256 "4596d92473dd87bfce5805e61d321aa68cc6a6d90774299b3a34eba6ff500afe" => :el_capitan
    sha256 "153183f4b20ecfed178416395a0e5ff6f55c6feb38a6c19c3cccfa6d80730002" => :yosemite
    sha256 "ff053a159b1b06e3d3507fc5deabc42b68e2a72128dbb40d668689746d803fba" => :mavericks
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
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
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
