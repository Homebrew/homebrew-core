class Gssdp < Formula
  desc "GUPnP library for resource discovery and announcement over SSDP"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gssdp/1.0/gssdp-1.0.0.tar.xz"
  sha256 "1b1df551df5ff4d856d064f785753a2eabccb89c358bae9f23f4b88c5c984173"

  bottle do
    sha256 "fc40fe391f342580a72035ed6f99e2bab7c0673f87dc6d75ba3a72b8ae80b6c2" => :sierra
    sha256 "bb3bd6262597d452e76e8e7cf9bfae9f0a894a88384b38f4e6fba6e34f439efb" => :el_capitan
    sha256 "99733c9ae851b23df2bd0f83ac3f1ae2509dcc580ce38e8787f4de216748ce59" => :yosemite
    sha256 "ab33195c31c56ef95a8eca198f8628ad31b9df3af45b086ffaefe1e459b9c408" => :mavericks
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
