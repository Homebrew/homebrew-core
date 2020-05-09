class Graphene < Formula
  desc "Thin layer of graphic data types"
  homepage "https://ebassi.github.io/graphene/"
  url "https://download.gnome.org/sources/graphene/1.10/graphene-1.10.0.tar.xz"
  sha256 "406d97f51dd4ca61e91f84666a00c3e976d3e667cd248b76d92fdb35ce876499"
  revision 2

  bottle do
    cellar :any
    sha256 "8e9ccfc7e14e4755ec082dd5ca83fbb1c1025a311949b63cbd74c59841c9b527" => :catalina
    sha256 "a083a3f2126a6adbf43167b553d60bb65fc08c4abd47334dfbca1bfea3ce3b59" => :mojave
    sha256 "ffd7960ecb178c6e60672ceabafca351e5f7843d1bbb964da48c3896fbe8374f" => :high_sierra
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
