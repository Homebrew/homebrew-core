class Gom < Formula
  desc "GObject wrapper around SQLite"
  homepage "https://wiki.gnome.org/Projects/Gom"
  url "https://download.gnome.org/sources/gom/0.4/gom-0.4.tar.xz"
  sha256 "68d08006aaa3b58169ce7cf1839498f45686fba8115f09acecb89d77e1018a9d"
  revision 1

  bottle do
    cellar :any
    sha256 "2d41e90512e737bfd112ba64278fda9c0dbaf1ab7dbd00732ed6ebb644da31e0" => :catalina
    sha256 "619f71c318e02d8c33e4d827aedfaad09d6f349d92408bb9a40097dba99eb65e" => :mojave
    sha256 "7566dd0ded406861960ebd556ce0d7f7e6e48eac4e72ab88aa9934d554ad638b" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"

  def install
    pyver = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"

    mkdir "build" do
      system "meson", *std_meson_args, "-Dpygobject-override-dir=#{lib}/python#{pyver}/site-packages", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gom/gom.h>

      int main(int argc, char *argv[]) {
        GType type = gom_error_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gom-1.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lgobject-2.0
      -lgom-1.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
