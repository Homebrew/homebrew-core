class Cairo < Formula
  desc "Vector graphics library with cross-device output support"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/cairo-1.16.0.tar.xz"
  sha256 "5e7b29b3f113ef870d1e3ecf8adf21f923396401604bda16d44be45e66052331"
  revision 1

  bottle do
    sha256 "163ee9334a7cfd0430546345b42c48c1241ec6f662bcb53166899b0b29f5e01a" => :mojave
    sha256 "cdfc4922055c9fe92487ac48fdb7d4b7a182f9f06826405e0bd6bc1acf64d538" => :high_sierra
    sha256 "704a151cbd8d5cd7331f9996882e068ce429438c45269dff3632e308578dc593" => :sierra
  end

  head do
    url "https://anongit.freedesktop.org/git/cairo", :using => :git
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "glib"
  depends_on "libpng"
  depends_on "pixman"

  def install
    if build.head?
      ENV["NOCONFIGURE"] = "1"
      system "./autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gobject=yes",
                          "--enable-svg=yes",
                          "--enable-tee=yes",
                          "--enable-quartz-image",
                          "--enable-xcb=no",
                          "--enable-xlib=no",
                          "--enable-xlib-xrender=no"
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
