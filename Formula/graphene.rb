class Graphene < Formula
  desc "Thin layer of graphic data types"
  homepage "https://ebassi.github.io/graphene/"
  url "https://download.gnome.org/sources/graphene/1.10/graphene-1.10.2.tar.xz"
  sha256 "e97de8208f1aac4f913d4fa71ab73a7034e807186feb2abe55876e51c425a7f6"

  bottle do
    cellar :any
    sha256 "d8519d2811ee796969121cd0b087fb7a5e96c2952c69bb2dfe206f3efc299e31" => :catalina
    sha256 "0e7e238034cfcd390b8bd0e49bd6ba3c23dcdbff7c9a1cea5e626b34a3381acb" => :mojave
    sha256 "7bcd5ab83e1509ddeec6b710ba2a69c99bb92438344694423b1c886346fd44c2" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
