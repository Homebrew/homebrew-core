class Gwyddion < Formula
  desc "Scanning Probe Microscopy visualization and analysis tool"
  homepage "http://gwyddion.net/"
  url "http://gwyddion.net/download/2.61/gwyddion-2.61.tar.gz"
  sha256 "ae9d647b1c8c44d91d4ebec3d22d7536299fdb16bfa0bacccdf64e4704cd355e"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://gwyddion.net/download.php"
    regex(/stable version Gwyddion v?(\d+(?:\.\d+)+):/i)
  end

  bottle do
    sha256 arm64_monterey: "af9865335f78231bee3ff95b2def880998fc437853112b03696a4d2c52c5580e"
    sha256 arm64_big_sur:  "9a5ba5a71bd35ec492de7fe9840419ec8922daf04a31c9ebb58ba8bee59c9723"
    sha256 monterey:       "d64d78a7b938e5147a787e9ea6276496f6e4b97fd7979534d715a04bc19ff79d"
    sha256 big_sur:        "acfbd4430428e964b062cd8f5e43cf96fad56127801b57e07493f3550efe3eac"
    sha256 catalina:       "ea3562016bd81e226579e0f92aa161d4551a870e46edb25dfae5bf38c0d0874b"
    sha256 x86_64_linux:   "991d25f826d4903328f4c15bd88ad8a405aba45074408deaef8982a8c24cb41b"
  end

  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "gtk+"
  depends_on "gtkglext"
  depends_on "gtksourceview"
  depends_on "libxml2"
  depends_on "minizip"

  on_macos do
    # Regenerate autoconf files to avoid flat namespace in library
    # (autoreconf runs gtkdocize, provided by gtk-doc)
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
    depends_on "gtk-mac-integration"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if OS.mac?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-desktop-file-update",
                          "--prefix=#{prefix}",
                          "--with-html-dir=#{doc}",
                          "--disable-pygwy"
    system "make", "install"
  end

  test do
    system "#{bin}/gwyddion", "--version"
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
