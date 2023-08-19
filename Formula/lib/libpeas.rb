class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://wiki.gnome.org/Projects/Libpeas"
  url "https://download.gnome.org/sources/libpeas/1.36/libpeas-1.36.0.tar.xz"
  sha256 "297cb9c2cccd8e8617623d1a3e8415b4530b8e5a893e3527bbfd1edd13237b4c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "5035cbd0ee756c5ee11237a3a76793f8baddf9efd7ac642942655d7dee6f0263"
    sha256 arm64_monterey: "c41fbcf2dd609afa94e61573ddc2d696e3319c736be0cb6a7287ab124ab27edb"
    sha256 arm64_big_sur:  "1e84d7e5d18d247efb35a15750fae0d5639ccf1bdc566d24171527682ee9259e"
    sha256 ventura:        "b1f6f50765a449fb859b31775ee9c8fd3b7719619749e217af51fd34d2b7ddef"
    sha256 monterey:       "17b8dba6575562741d55c46022e0bfddca9223d389955990712679b1436f27d0"
    sha256 big_sur:        "ccbf503dc2c680a7f0ba32f0a22e05e68bc2a7d50557c4754c8de7f473f32724"
    sha256 x86_64_linux:   "3df218b0dcc953b55eb149454943c4ccead6397720b313dd65af783ccd03ab49"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.11"

  def install
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
