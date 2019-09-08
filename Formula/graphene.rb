class Graphene < Formula
  desc "Thin layer of graphic data types"
  homepage "https://ebassi.github.io/graphene/"
  url "https://download.gnome.org/sources/graphene/1.10/graphene-1.10.0.tar.xz"
  sha256 "406d97f51dd4ca61e91f84666a00c3e976d3e667cd248b76d92fdb35ce876499"

  bottle do
    cellar :any
    sha256 "14955a68031fdc7e48a9f0b6438a59fec32495bf5a4afa21173977027146a376" => :mojave
    sha256 "ce298f614ae9c0bacb0a0d7856db30ad25ff27bfc2f8bb18193a08d8ad83fd2f" => :high_sierra
    sha256 "2647d2925ca5a6f5da5375e7b8b4fc6080248ea2c576cc8914376a8c05076fb0" => :sierra
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
