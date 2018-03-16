class Cairo < Formula
  desc "Vector graphics library with cross-device output support"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/cairo-1.14.12.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/cairo-1.14.12.tar.xz"
  sha256 "8c90f00c500b2299c0a323dd9beead2a00353752b2092ead558139bd67f7bf16"

  bottle do
    sha256 "5bdc28de8e5a615ab664d43f7f322ed02d58071171415bb6e2750f486b9465e2" => :high_sierra
    sha256 "102847d74a0a11bb6143d93b9f32e1736e88036fb4c685d554a8bcd376bbd929" => :sierra
    sha256 "bec85433a35605164bdbf5f8913e29eb6d9ceb5acc5569dd9d864706ae6c8d49" => :el_capitan
  end

  head do
    url "https://anongit.freedesktop.org/git/cairo", :using => :git
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_pre_mountain_lion

  depends_on "pkg-config" => :build
  depends_on :x11 => :optional
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "libpng"
  depends_on "pixman"
  depends_on "glib"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-gobject=yes
      --enable-svg=yes
      --enable-tee=yes
      --enable-quartz-image
    ]

    if build.with? "x11"
      args << "--enable-xcb=yes" << "--enable-xlib=yes" << "--enable-xlib-xrender=yes"
    else
      args << "--enable-xcb=no" << "--enable-xlib=no" << "--enable-xlib-xrender=no"
    end

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <cairo.h>

      int main(int argc, char *argv[]) {

        cairo_surface_t *surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 600, 400);
        cairo_t *context = cairo_create(surface);

        return 0;
      }
    EOS
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libpng = Formula["libpng"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/cairo
      -I#{libpng.opt_include}/libpng16
      -I#{pixman.opt_include}/pixman-1
      -L#{lib}
      -lcairo
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
