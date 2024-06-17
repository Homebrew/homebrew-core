class LibpeasAT1 < Formula
  desc "GObject plugin library"
  homepage "https://wiki.gnome.org/Projects/Libpeas"
  url "https://download.gnome.org/sources/libpeas/1.36/libpeas-1.36.0.tar.xz"
  sha256 "297cb9c2cccd8e8617623d1a3e8415b4530b8e5a893e3527bbfd1edd13237b4c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "296cfa4be7883c30a452192c5fc0af1114b3a95a85e7bd15f6ee2e6cd3b5b05b"
    sha256 arm64_ventura:  "7f3aed830c0abca6806d100cb30ada639a223761b866b7d870a24cc29f7ceb95"
    sha256 arm64_monterey: "9e6763a072391563182307fec28517f34fee434160b33760b2c63a06c691c5cb"
    sha256 sonoma:         "b7f54ae9f76cf2d17335fd455e6a8708067e8250148194ef4903e9555fcb9879"
    sha256 ventura:        "4a4c0eb59123d0f8a65af0c4c1b98f904375264858e3f9b67eb47ac12780ed4e"
    sha256 monterey:       "9009e72591f1845fd6fb3c37a763c172efbc8c933421f7cc7092d5af56370df9"
    sha256 x86_64_linux:   "2a9915d4ede2be0fd7a7816c4cafc285e235fc1188d83966011a2b4e611e7c85"
  end

  keg_only :versioned_formula

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.12"

  def install
    pyver = Language::Python.major_minor_version "python3.12"
    # Help pkg-config find python as we only provide `python3-embed` for aliased python formula
    inreplace "meson.build", "'python3-embed'", "'python-#{pyver}-embed'"

    args = %w[
      -Dpython3=true
      -Dintrospection=true
      -Dvapi=true
      -Dwidgetry=true
      -Ddemos=false
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libpeas/peas.h>

      int main(int argc, char *argv[]) {
        PeasObjectModule *mod = peas_object_module_new("test", "test", FALSE);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gobject_introspection = Formula["gobject-introspection"]
    libffi = Formula["libffi"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gobject_introspection.opt_include}/gobject-introspection-1.0
      -I#{include}/libpeas-1.0
      -I#{libffi.opt_lib}/libffi-3.0.13/include
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gobject_introspection.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lgirepository-1.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lpeas-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
