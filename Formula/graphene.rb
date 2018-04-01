class Graphene < Formula
  desc "Thin layer of graphic data types"
  homepage "https://ebassi.github.io/graphene/"
  url "https://download.gnome.org/sources/graphene/1.8/graphene-1.8.0.tar.xz"
  sha256 "7bbc8e2f183acb522e1d9fe256f5fb483ce42260bfeb3ae69320aeb649dd8d91"

  bottle do
    sha256 "376d06cf0f650494fafa2bcc8f781fec0d25a13a268b99512f7f1db597d814a0" => :high_sierra
    sha256 "9e9932539d448d94b967425a4675aa85e93cba6c831baec94f23e8be20039c3f" => :sierra
    sha256 "8815a5bc85dfbc5d05b1ae521c9db2f3a2b1b740ef415c0ab74be8b2a64be167" => :el_capitan
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
