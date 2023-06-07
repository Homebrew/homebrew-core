class ClutterGtk < Formula
  desc "GTK+ integration library for Clutter"
  homepage "https://wiki.gnome.org/Projects/Clutter"
  url "https://download.gnome.org/sources/clutter-gtk/1.8/clutter-gtk-1.8.4.tar.xz"
  sha256 "521493ec038973c77edcb8bc5eac23eed41645117894aaee7300b2487cb42b06"
  revision 4

  bottle do
    sha256                               arm64_ventura:  "7bdda03538852053c87def6ab4bf02a8a040389e25ddbaafc3a3d1d29de499ae"
    sha256                               arm64_monterey: "28a3283252422dbc864b7beb4c69e377688c33fbb2a0e535c62a9362264162bf"
    sha256                               arm64_big_sur:  "2fe413931adfbb5801835172149dbf10aa1f1cdc669a0a8f973d834a6251fe0f"
    sha256                               ventura:        "f26d721d02014fdc016c0fec68ed9d2d58b2ea101ed3460bd16566ccd009ea4b"
    sha256                               monterey:       "3940367b212abbe0c266ea8982aa82cc890d8ab8f24c2c851362283a0aef5a3f"
    sha256                               big_sur:        "4d0e9365bfeff618403fb3fa6db9319eb684b4c614af80f1ad6ed0f0fec57db1"
    sha256                               catalina:       "4b5c17d3567f1a5c03f98ccc8d9275f07fa733770d4ee741800505b8894442a1"
    sha256                               mojave:         "665ed256370965e0f1e8660bf1f0372a7e5a9ea0fde176c06cb4c8e390a0739c"
    sha256                               high_sierra:    "90929f36d6105b2b046e32f2d661c91305b785da535a7654fde19eb89617008e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae50137a8bf0f24cc4ea36fe43e5d16f295968ab2efa30c9af8abcb5513ba70f"
  end

  # https://blogs.gnome.org/clutter/2022/02/16/retiring-clutter/
  deprecate! date: "2022-09-21", because: :deprecated_upstream

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "clutter"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --prefix=#{prefix}
      --enable-introspection=yes
      --disable-silent-rules
      --disable-gtk-doc-html
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <clutter-gtk/clutter-gtk.h>

      int main(int argc, char *argv[]) {
        GOptionGroup *group = gtk_clutter_get_option_group();
        return 0;
      }
    EOS
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
      -I#{include}/clutter-gtk-1.0
      -I#{json_glib.opt_include}/json-glib-1.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{clutter.opt_lib}
      -L#{cogl.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{json_glib.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lclutter-1.0
      -lclutter-gtk-1.0
      -lcogl
      -lcogl-pango
      -lcogl-path
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lgtk-3
      -ljson-glib-1.0
      -lpango-1.0
      -lpangocairo-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
