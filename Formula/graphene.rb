class Graphene < Formula
  desc "Thin layer of graphic data types"
  homepage "https://ebassi.github.io/graphene/"
  url "https://download.gnome.org/sources/graphene/1.10/graphene-1.10.0.tar.xz"
  sha256 "406d97f51dd4ca61e91f84666a00c3e976d3e667cd248b76d92fdb35ce876499"

  bottle do
    cellar :any
    sha256 "34bbd2f5b245e2c6bd7205cbd72f9c42b4410c515d526239340b1d62b7d9c1cd" => :catalina
    sha256 "3d50bdcd26cee560b210108fa71abbea9cc5e747ea733fa327d23835ed2f78fb" => :mojave
    sha256 "d5d25240fa183463100d935d5500a54a82a80d09c60b5066093ad5b34c9dd0b9" => :high_sierra
    sha256 "faedb0110f39db296ce897ee2b043ce10a24317e2a70f2c533b3cb33ca0c2f46" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "glib"

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
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
