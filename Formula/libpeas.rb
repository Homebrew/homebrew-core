class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://wiki.gnome.org/Projects/Libpeas"
  url "https://download.gnome.org/sources/libpeas/1.32/libpeas-1.32.0.tar.xz"
  sha256 "d625520fa02e8977029b246ae439bc218968965f1e82d612208b713f1dcc3d0e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "95e58fd14df242b90173b9ba0d5d40b8234e84f87cc6ebc30b3824928cbf205e"
    sha256 arm64_big_sur:  "bc72e8a73ee764c86763198b676002e6a1edd724572920e30a4757048a8c0388"
    sha256 monterey:       "ec9eeb3cdf1f4272b23e0a34c32eb26b4438ae07f4800c7981fdf9fc35e124a7"
    sha256 big_sur:        "23f1cf3fdadc9f3586e442a7bafbe3ddc781063578bc1728ddcb818646f304d3"
    sha256 catalina:       "57cba039daf7d11664e656f8fd3d02fe1083fd3ab11c7e45ba025b621fa325a5"
    sha256 x86_64_linux:   "f994ca714e319d0cdff07e30f37fc0794887fee5389fff0dfb818e104e65621d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.9"

  def install
    args = std_meson_args + %w[
      -Dpython3=true
      -Dintrospection=true
      -Dvapi=true
      -Dwidgetry=true
      -Ddemos=false
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
