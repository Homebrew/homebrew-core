class Libchamplain < Formula
  desc "ClutterActor for displaying maps"
  homepage "https://wiki.gnome.org/Projects/libchamplain"
  url "https://download.gnome.org/sources/libchamplain/0.12/libchamplain-0.12.21.tar.xz"
  sha256 "a915cd172a0c52944c5579fcb4683f8a878c571bf5e928254b5dafefc727e5a7"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "5178bf3638a2027f1d5664fa78e2347879e0882d7a3181166dbad9b49121dab9"
    sha256 cellar: :any, arm64_monterey: "2f252ae4637021bb9f29636cfc2b20d3dab10b04207d06152b4a47d812c52058"
    sha256 cellar: :any, arm64_big_sur:  "33c868d4bc619d31a4938952dece38e447aee5e4c18f89994b29d41eb3dd411d"
    sha256 cellar: :any, ventura:        "9962bd6ca9db0599c17a63e2f207342e88d7cdafc6230a982c2e91cfc26ac92d"
    sha256 cellar: :any, monterey:       "c5c68414f285b6ffc0ce1c3f2cf160083d45596ad64454e7260bb266812730c3"
    sha256 cellar: :any, big_sur:        "2945d61373d9f1d984c48b40be8718b79defe25033f65d8ad70662a143328b01"
    sha256 cellar: :any, catalina:       "2b4c4d1e01b47b3598b56d92b27a42b944a56c83b73f1e175e6854210dfe465e"
    sha256               x86_64_linux:   "5a616be881e0a1a0cd3a9c1064006c14f5e909df6366abbf5527523b380ef3e3"
  end

  # It needs deprecated `cogl` and `clutter`. There isn't a plan to rewrite and homepage says:
  # "Starting with GTK4, it is recommended to use libshumate instead of libchamplain"
  # Ref: https://wiki.gnome.org/Projects/libchamplain
  # Ref: https://gitlab.gnome.org/GNOME/libchamplain/-/issues/50
  # Ref: https://gitlab.gnome.org/GNOME/libchamplain/-/issues/52
  disable! date: "2023-09-25", because: :unmaintained

  depends_on "gnome-common" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "clutter"
  depends_on "clutter-gtk"
  depends_on "gtk+3"
  depends_on "libsoup"
  depends_on "sqlite" # try to change to uses_from_macos after python is not a dependency

  on_linux do
    depends_on "vala" => :build
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <champlain/champlain.h>

      int main(int argc, char *argv[]) {
        GType type = champlain_license_get_type();
        return 0;
      }
    EOS
    ENV.libxml2
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    clutter = Formula["clutter"]
    cogl = Formula["cogl"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx3 = Formula["gtk+3"]
    harfbuzz = Formula["harfbuzz"]
    json_glib = Formula["json-glib"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    libsoup = Formula["libsoup"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{clutter.opt_include}/clutter-1.0
      -I#{cogl.opt_include}/cogl
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/champlain-0.12
      -I#{json_glib.opt_include}/json-glib-1.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{libsoup.opt_include}/libsoup-3.0
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{clutter.opt_lib}
      -L#{cogl.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{json_glib.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lchamplain-0.12
      -lclutter-1.0
      -lcogl
      -lcogl-pango
      -lcogl-path
      -lgio-2.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -ljson-glib-1.0
      -lpango-1.0
      -lpangocairo-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
