class Graphene < Formula
  desc "Thin layer of graphic data types"
  homepage "https://ebassi.github.io/graphene/"
  url "https://download.gnome.org/sources/graphene/1.6/graphene-1.6.2.tar.xz"
  sha256 "8f7d1984c06aefe3b47a668c12ad9f3db0bcb2d09c55e6267b82a90f6b10d961"
  revision 2

  bottle do
    sha256 "376d06cf0f650494fafa2bcc8f781fec0d25a13a268b99512f7f1db597d814a0" => :high_sierra
    sha256 "9e9932539d448d94b967425a4675aa85e93cba6c831baec94f23e8be20039c3f" => :sierra
    sha256 "8815a5bc85dfbc5d05b1ae521c9db2f3a2b1b740ef415c0ab74be8b2a64be167" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "python"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <graphene-gobject.h>

      int main(int argc, char *argv[]) {
      GType type = graphene_point_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/graphene-1.0
      -I#{lib}/graphene-1.0/include
      -L#{lib}
      -lgraphene-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
