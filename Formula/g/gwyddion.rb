class Gwyddion < Formula
  desc "Scanning Probe Microscopy visualization and analysis tool"
  homepage "http://gwyddion.net/"
  url "https://downloads.sourceforge.net/project/gwyddion/gwyddion/2.66/gwyddion-2.66.tar.xz"
  sha256 "377bedcd2b0d8d133a329686da9f5f91807ff1d47937f9991195f1e863792d52"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://gwyddion.net/download.php"
    regex(/stable version Gwyddion v?(\d+(?:\.\d+)+):/i)
  end

  bottle do
    sha256 arm64_sonoma:   "92520b5d7c96c979979e90d2c9262bfac04fcf01886ab88da9e1e5737243890f"
    sha256 arm64_ventura:  "c6239179ab6f4d4870721daa70ac7f75dbe745bfe23abb5789c21973e4bc8038"
    sha256 arm64_monterey: "e58cd64b5695c615cc628523572e3d9f7304570e062c814c91bdeb6459b61f2a"
    sha256 sonoma:         "0b8831b14f01286a37851e0f8931040950ee65121ea1ace70beab457fc9cd1a3"
    sha256 ventura:        "9758d09277d9b6e4d46c9524a296a2b27df41d6dcdd48537ee44ab90dff20dac"
    sha256 monterey:       "8f4019049aad4c6a55e79c909b449263a58f6e80f79eaa92da6d7ad2d9219c83"
    sha256 x86_64_linux:   "9af968081422a5b12d4c4bfb433e347e487c6373e67e2a1398e51630f96a72f5"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fftw"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "gtkglext"
  depends_on "libpng"
  depends_on "libxml2"
  depends_on "minizip"
  depends_on "pango"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    # Regenerate autoconf files to avoid flat namespace in library
    # (autoreconf runs gtkdocize, provided by gtk-doc)
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
    # TODO: depends_on "gtk-mac-integration"
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if OS.mac?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-desktop-file-update",
                          "--with-html-dir=#{doc}",
                          "--without-gtksourceview",
                          "--disable-pygwy"
    system "make", "install"
  end

  test do
    system bin/"gwyddion", "--version"
    (testpath/"test.c").write <<~EOS
      #include <libgwyddion/gwyddion.h>

      int main(int argc, char *argv[]) {
        const gchar *string = gwy_version_string();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fftw = Formula["fftw"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx = Formula["gtk+"]
    gtkglext = Formula["gtkglext"]
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fftw.opt_include}
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkglext.opt_include}/gtkglext-1.0
      -I#{gtkglext.opt_lib}/gtkglext-1.0/include
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/gwyddion
      -I#{libpng.opt_include}/libpng16
      -I#{lib}/gwyddion/include
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{fftw.opt_lib}
      -L#{fontconfig.opt_lib}
      -L#{freetype.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkglext.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lfftw3
      -lfontconfig
      -lfreetype
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lgwyapp2
      -lgwyddion2
      -lgwydgets2
      -lgwydraw2
      -lgwymodule2
      -lgwyprocess2
      -lpango-1.0
      -lpangocairo-1.0
      -lpangoft2-1.0
    ]

    if OS.mac?
      flags += %w[
        -lintl
        -lgdk-quartz-2.0
        -lgdkglext-quartz-1.0
        -lgtk-quartz-2.0
        -lgtkglext-quartz-1.0
        -framework AppKit
        -framework OpenGL
      ]
    end

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
