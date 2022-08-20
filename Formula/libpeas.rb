class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://wiki.gnome.org/Projects/Libpeas"
  url "https://download.gnome.org/sources/libpeas/1.32/libpeas-1.32.0.tar.xz"
  sha256 "d625520fa02e8977029b246ae439bc218968965f1e82d612208b713f1dcc3d0e"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_monterey: "3f00cc64bd20322cdcb213ef36a01bbfeee946e6529e562b47cdb6907cc4f83c"
    sha256 arm64_big_sur:  "fd5a0bc995f0f819d7e191cc57880664d3b7352d75ea92b2f76ffdc1b0069209"
    sha256 monterey:       "7b8a356081a65abb5c23fda43f2e4353cacb0182229cdcacbfbe4d4de59d80d6"
    sha256 big_sur:        "38ae27203ce4ed3ea930414be2f1a10bc3488d3be721e34ac96f2477f0096c64"
    sha256 catalina:       "9027603f11c76d48af9285bd6e9f46c6d898569bdd29c99c52a66c2f3c34879d"
    sha256 x86_64_linux:   "06dca0f0281702151b8809b797f6b1931ff69b05f73ed266f0e0af725b563e4f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.10"

  def install
    # This shouldn't be needed, but this fails to link with libpython3.10.so.
    # TODO: Remove this when `python@3.10` is no longer keg-only.
    ENV.append "LDFLAGS", "-Wl,-rpath,#{Formula["python@3.10"].opt_lib}" if OS.linux?

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
