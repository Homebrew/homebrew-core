class Libdazzle < Formula
  desc "GNOME companion library to GObject and Gtk+"
  homepage "https://gitlab.gnome.org/GNOME/libdazzle"
  url "https://download.gnome.org/sources/libdazzle/3.42/libdazzle-3.42.0.tar.xz"
  sha256 "eae67a3b3d9cce408ee9ec0ab6adecb83e52eb53f9bc93713f4df1e84da16925"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "bd3d5fe0c3f40cc3046d824af353bd7c8a333a88fb28893df41854a7c9b551d5"
    sha256 cellar: :any,                 big_sur:       "05b5ef35b6edbae5dee76b55549de030b1876e75a7d2caa3d5f877a6c64c26c8"
    sha256 cellar: :any,                 catalina:      "28328021ecdcf4eeabc6146a73a4c61652ea214036705a6b0441fabc81c5196b"
    sha256 cellar: :any,                 mojave:        "0a9f674293a1df2ef75d633392309cd759654f39e973600bc19276763c1290d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3d3ab5671c26fd3f58d81efd7cb75eb2e484f5e74c875ba6d8ac3c17edace88"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gtk+3"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dwith_vapi=true", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <dazzle.h>

      int main(int argc, char *argv[]) {
        g_assert_false(dzl_file_manager_show(NULL, NULL));
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    graphite2 = Formula["graphite2"]
    gtkx3 = Formula["gtk+3"]
    harfbuzz = Formula["harfbuzz"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pcre = Formula["pcre"]
    pixman = Formula["pixman"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{graphite2.opt_include}
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/libdazzle-1.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pcre.opt_include}
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -ldazzle-1.0
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-3
      -lpango-1.0
      -lpangocairo-1.0
    ]
    on_macos do
      flags << "-lintl"
      flags << "-Wl,-framework"
      flags << "-Wl,CoreFoundation"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
