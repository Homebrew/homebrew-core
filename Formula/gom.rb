class Gom < Formula
  desc "GObject wrapper around SQLite"
  homepage "https://wiki.gnome.org/Projects/Gom"
  url "https://download.gnome.org/sources/gom/0.3/gom-0.3.3.tar.xz"
  sha256 "ac57e34b5fe273ed306efaeabb346712c264e341502913044a782cdf8c1036d8"
  revision 1

  bottle do
    cellar :any
    sha256 "6f7a96ec76e481f0e6af7954ee498d011f4cadb8e476be85f551104d9d8df0ca" => :high_sierra
    sha256 "882d4995285571d08bc7a1579edc1d4b5407c6b14b3e7bd7066f6a9fc16f2f82" => :sierra
    sha256 "fcc8ee964d6e9ba4df256f6375c0ff868cf6c67171cc5dfc2080662bc77cbbb0" => :el_capitan
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "py3cairo"
  depends_on "pygobject3" => "with-python3"
  depends_on "python3"
  depends_on "sqlite"

  def install
    ENV.refurbish_args

    pyver = Language::Python.major_minor_version "python3"

    # prevent sandbox violation
    inreplace "bindings/python/meson.build",
              "install_dir: pygobject_override_dir",
              "install_dir: '#{lib}/python#{pyver}/site-packages'"

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
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
