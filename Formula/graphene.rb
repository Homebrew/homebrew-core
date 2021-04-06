class Graphene < Formula
  desc "Thin layer of graphic data types"
  homepage "https://ebassi.github.io/graphene/"
  url "https://github.com/ebassi/graphene/releases/download/1.10.6/graphene-1.10.6.tar.xz"
  sha256 "80ae57723e4608e6875626a88aaa6f56dd25df75024bd16e9d77e718c3560b25"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7630fe796cca6bd73eed68a742fc9f3b36f7246be829af8035f370229340b385"
    sha256 cellar: :any, big_sur:       "70cb37a4d8f83d64b08b028970ae895cdac896c13a4a14b51bbbc10df15f7ad4"
    sha256 cellar: :any, catalina:      "236ccbb6dddc03eb4ca4bbc41e5488f7abeb5943bd73650a7c9887c3a3da5afb"
    sha256 cellar: :any, mojave:        "d6ff56ed1cbaf09f158c1936e6b60aa08ea65c5342a31596dda6c1f05312abe2"
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
