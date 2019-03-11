class Atk < Formula
  desc "GNOME accessibility toolkit"
  homepage "https://library.gnome.org/devel/atk/"
  url "https://download.gnome.org/sources/atk/2.32/atk-2.32.0.tar.xz"
  sha256 "cb41feda7fe4ef0daa024471438ea0219592baf7c291347e5a858bb64e4091cc"

  bottle do
    sha256 "ef98c860ad49b7c335854dc8a558e193353a8afad8d22d0bc1be1d82ccc716c7" => :mojave
    sha256 "13a414fd51dc409c7fb66ff5a91920f11cda4a18e311b16249df7a1395e8f2b5" => :high_sierra
    sha256 "945bbdb2a8e1ed4802a9b437fcdfccd59d0de099bcbee66e32a42f7cf9c86896" => :sierra
    sha256 "786efff084a599afbdc9ab706da2e64ae1c4fc29110ab8f7379649a9651599e2" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
    end

    # to be removed when https://gitlab.gnome.org/GNOME/gobject-introspection/issues/222 is fixed
    inreplace share/"gir-1.0/Atk-1.0.gir", "@rpath", lib.to_s
    system "g-ir-compiler", "--output=#{lib}/girepository-1.0/Atk-1.0.typelib", share/"gir-1.0/Atk-1.0.gir"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <atk/atk.h>

      int main(int argc, char *argv[]) {
        const gchar *version = atk_get_version();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/atk-1.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -latk-1.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
