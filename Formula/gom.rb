class Gom < Formula
  desc "GObject wrapper around SQLite"
  homepage "https://wiki.gnome.org/Projects/Gom"
  url "https://download.gnome.org/sources/gom/0.3/gom-0.3.3.tar.xz"
  sha256 "ac57e34b5fe273ed306efaeabb346712c264e341502913044a782cdf8c1036d8"

  bottle do
    sha256 "10ba2ee65e74ce7a7da2e4671c090b01a65d3c2cbeab153c1e80b6caf3997abc" => :sierra
    sha256 "c0d7ef477da47db79a99241bf4e514a74a43f2390c5c90b3a8eb11851f6a4b44" => :el_capitan
    sha256 "060cf100046bd8bedf1ba4df90527754102fea42c7b20ff6147f813bd3c5fb8b" => :yosemite
    sha256 "1c67b623bf29a0dabedf0cf2c686d1b22f3b28ff0a227fe96624754a14feb88f" => :mavericks
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "py3cairo"
  depends_on "pygobject3" => "with-python3"
  depends_on :python3
  depends_on "sqlite"

  def install
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
    (testpath/"test.c").write <<-EOS.undent
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
