class ClutterGst < Formula
  desc "ClutterMedia interface using GStreamer for video and audio"
  homepage "https://gitlab.gnome.org/GNOME/clutter-gst"
  url "https://download.gnome.org/sources/clutter-gst/3.0/clutter-gst-3.0.27.tar.xz"
  sha256 "fe69bd6c659d24ab30da3f091eb91cd1970026d431179b0724f13791e8ad9f9d"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_monterey: "c1094b27e618b50d8bc57be10e87f2858608584cf952c499000636866f763c8d"
    sha256 arm64_big_sur:  "bd23c3da4a8e9c35bb93bb043967defead1d749e15d912006f48b51cd1e467d4"
    sha256 monterey:       "df2e7cc17a0b1c88a927eed54578a00fefd0908e537a36916f5a8a2cb6e61f41"
    sha256 big_sur:        "e9d8f94e727561a95238da6366eb59589e9342edc8fd0a0eb6af86ce91aa9ef4"
    sha256 catalina:       "9e5e48bdf08599d63be7a75eabac3221ce4b1799fcf51d857d37336345393c16"
    sha256 mojave:         "3c4dcfd6b9b95d1f0a96e33d23060225c322224e21e4501c8e2b5a6ef32a9ebe"
    sha256 high_sierra:    "b60c1d84cf2f4e9cf931d10ce759d4b21f08a7a2288dd81cbab78854d3a767a2"
    sha256 sierra:         "fb997fb8ac4fcafd52690d64c12dfcd7776630ce717521c7cc0ce7d44ae3b8f7"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "clutter"
  depends_on "gdk-pixbuf"
  depends_on "gst-plugins-base"
  depends_on "gstreamer"

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
      #include <clutter-gst/clutter-gst.h>

      int main(int argc, char *argv[]) {
        clutter_gst_init(&argc, &argv);
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
    gst_plugins_base = Formula["gst-plugins-base"]
    gstreamer = Formula["gstreamer"]
    harfbuzz = Formula["harfbuzz"]
    json_glib = Formula["json-glib"]
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
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gst_plugins_base.opt_include}/gstreamer-1.0
      -I#{gstreamer.opt_include}/gstreamer-1.0
      -I#{gstreamer.opt_lib}/gstreamer-1.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/clutter-gst-3.0
      -I#{json_glib.opt_include}/json-glib-1.0
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
      -L#{gst_plugins_base.opt_lib}
      -L#{gstreamer.opt_lib}
      -L#{json_glib.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lclutter-1.0
      -lclutter-gst-3.0
      -lcogl
      -lcogl-pango
      -lcogl-path
      -lgio-2.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lgstbase-1.0
      -lgstreamer-1.0
      -lgstvideo-1.0
      -ljson-glib-1.0
      -lpango-1.0
      -lpangocairo-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
