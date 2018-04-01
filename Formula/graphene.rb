class Graphene < Formula
  desc "Thin layer of graphic data types"
  homepage "https://ebassi.github.io/graphene/"
  url "https://download.gnome.org/sources/graphene/1.8/graphene-1.8.0.tar.xz"
  sha256 "7bbc8e2f183acb522e1d9fe256f5fb483ce42260bfeb3ae69320aeb649dd8d91"

  bottle do
    sha256 "d8a08d1c0ef36ce8792a6e272b6e2bcf89595d4872e5cd07fbdebfab0f0aa636" => :high_sierra
    sha256 "ad4eeb8fabde86c6eec37bc63468aa54808fd140f9a9cfa7987e0f7b43b11672" => :sierra
    sha256 "4c46e8f9f8313940ecb601bf11a27159fb751b6e9a5c4faba7e8c116f539cb13" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "python" => :build
  depends_on "glib"

  def install
    ENV.refurbish_args

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
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
