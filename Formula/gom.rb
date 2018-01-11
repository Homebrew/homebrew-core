class Gom < Formula
  desc "GObject wrapper around SQLite"
  homepage "https://wiki.gnome.org/Projects/Gom"
  url "https://download.gnome.org/sources/gom/0.3/gom-0.3.3.tar.xz"
  sha256 "ac57e34b5fe273ed306efaeabb346712c264e341502913044a782cdf8c1036d8"
  revision 1

  bottle do
    cellar :any
    sha256 "6c881c4f323fdd61bb89e09c7f9d246736d0f9d77c8b1b37583561afe11cd264" => :high_sierra
    sha256 "0362cca9f99c933d1e2ff55e14c4a1bd6e29b603691ed31584c3c11ec047bba0" => :sierra
    sha256 "cb6b8b45f13d113c9be5008ce9dc92dd3e10dee96f7b0f6f1b2f6425a82fce92" => :el_capitan
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
