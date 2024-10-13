class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://wiki.gnome.org/Projects/Libpeas"
  url "https://download.gnome.org/sources/libpeas/2.0/libpeas-2.0.5.tar.xz"
  sha256 "376f2f73d731b54e13ddbab1d91b6382cf6a980524def44df62add15489de6dd"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "823a7e14c6824998266a429fb76a406048faf99ea6d530562a34ddaf3d8141d3"
    sha256 arm64_sonoma:  "f31f15cb8a9fc7715d5cdb2c017d8e1325453e1f5882f9b11e97d3ddb64f1cbd"
    sha256 arm64_ventura: "4fe81d0c5880a2671e0568fc8a203845b7ef0131e08296064bce9d50689c4709"
    sha256 sonoma:        "76c211768f09e686c3e3a0eef8c7b766cff4098cf3506c04d093f18c7be94730"
    sha256 ventura:       "a2c240b560490b396217018dff8aba7949016e508e9b2ded78653887f8338945"
    sha256 x86_64_linux:  "6457499ae5800a12684db70edf0ef2b2138b3fd0d96cc1a0e4c69f2b41186ebd"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gjs"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.12"
  depends_on "spidermonkey"

  on_macos do
    depends_on "gettext"
  end

  def install
    pyver = Language::Python.major_minor_version "python3.12"
    # Help pkg-config find python as we only provide `python3-embed` for aliased python formula
    inreplace "meson.build", "'python3-embed'", "'python-#{pyver}-embed'"

    args = %w[
      -Dlua51=false
      -Dpython3=true
      -Dintrospection=true
      -Dvapi=true
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libpeas.h>

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
      -I#{include}/libpeas-2
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
      -lpeas-2
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
