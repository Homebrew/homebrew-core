class Graphene < Formula
  desc "Thin layer of graphic data types"
  homepage "https://ebassi.github.io/graphene/"
  url "https://download.gnome.org/sources/graphene/1.6/graphene-1.6.2.tar.xz"
  sha256 "8f7d1984c06aefe3b47a668c12ad9f3db0bcb2d09c55e6267b82a90f6b10d961"

  bottle do
    sha256 "667e06c896b4d8c06dbd21ab0baf01a5c30d0121f1527623450d7bb7c2a39c5a" => :high_sierra
    sha256 "b93078c0775ecdb3ee709293f5500c9632aa91344f0958cac0eb362115ba124a" => :sierra
    sha256 "1b906d842080dcb12b3807c4c9405e53275421f68f93c30bfa6081e7e1957b14" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "python3"

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
