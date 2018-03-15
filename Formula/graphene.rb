class Graphene < Formula
  desc "Thin layer of graphic data types"
  homepage "https://ebassi.github.io/graphene/"
  url "https://download.gnome.org/sources/graphene/1.6/graphene-1.6.2.tar.xz"
  sha256 "8f7d1984c06aefe3b47a668c12ad9f3db0bcb2d09c55e6267b82a90f6b10d961"
  revision 1

  bottle do
    sha256 "4ed91e3d415e97cbb88432448e67199b74738705b5a859a6db1577cb1eab1441" => :high_sierra
    sha256 "08f58d77c34cdef2b11f4195e17d929438678a8ee1c98d8243cb3386c5d5c5f5" => :sierra
    sha256 "fb90bbbabde61e65bd5ef9afd48348bc855ffd418252b715b2e84b4d0a2de3ff" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
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
