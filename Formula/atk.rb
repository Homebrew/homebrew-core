class Atk < Formula
  desc "GNOME accessibility toolkit"
  homepage "https://library.gnome.org/devel/atk/"
  url "https://download.gnome.org/sources/atk/2.34/atk-2.34.0.tar.xz"
  sha256 "bd0714d57863c7f32e2f34388f309fdb4d5c22de69de9fa96ad19171e76605eb"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bef1913879e18e1ebb1374cea9099b469e627c143db1af84eb4ff952c0aa416a" => :mojave
    sha256 "a9c3a88fe56e0f9a881ec1d0256f20cfe79e6ff7a1bb181aae34a369d52e76b5" => :high_sierra
    sha256 "019ecba02c40d705a0479ec5ba997561faaad827f019d12e3f51030db2eb328b" => :sierra
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
