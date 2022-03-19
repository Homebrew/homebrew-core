class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://wiki.gnome.org/Projects/Libpeas"
  url "https://download.gnome.org/sources/libpeas/1.32/libpeas-1.32.0.tar.xz"
  sha256 "d625520fa02e8977029b246ae439bc218968965f1e82d612208b713f1dcc3d0e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "4555c023f4c109b99df899140d01a0cceedb4b27e735cc16d34c34bfb80e930c"
    sha256 arm64_big_sur:  "826333c759333b483af3466322a0c7f21cb723674f4a71e118ca8ad78ade4a70"
    sha256 monterey:       "81ec3bc432ee2b37567e7761019cf336ae35df10b8f7dd7088d981ea603e1648"
    sha256 big_sur:        "204fd26d92f3a9585d6823fff5df8a8108a0ed904c80a845e0bfd5173152c934"
    sha256 catalina:       "cddddc6a29c533bbff776cb2635a4494f3d7024f0c4aeb80e4e378427f790100"
    sha256 mojave:         "1df3679b835916a8c135edbbfa246e27cfdeac82717250505363f117130f9832"
    sha256 x86_64_linux:   "11d56ef35cd8c957bf3fde1cc63eeb5d3083cec638ae0520c63da1ed85c472df"
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
    on_macos do
      flags << "-lintl"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
