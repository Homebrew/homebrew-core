class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "http://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.3/gegl-0.3.32.tar.bz2"
  sha256 "a30e74ab2622b8c5e15c2a9ae27af72970bfa9380a67fde5211bf4bea7ade34d"

  bottle do
    sha256 "0db88cb1c562c03ddb9834ef65b59d87eac8762eae334c86744e11189a20c436" => :high_sierra
    sha256 "3c3b9e8d0a904638b36295a57c377ca7a409293789430f08d588079c88cf20f9" => :sierra
    sha256 "43200cb40da4e48622ba78a46b6cf34163825a321c60a34130cda9854ebd1a46" => :el_capitan
  end

  head do
    # Use the Github mirror because official git unreliable.
    url "https://github.com/GNOME/gegl.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "babl"
  depends_on "gettext"
  depends_on "glib"
  depends_on "jpeg"
  depends_on "json-glib"
  depends_on "libpng"
  depends_on "cairo" => :optional
  depends_on "librsvg" => :optional
  depends_on "lua" => :optional
  depends_on "pango" => :optional
  depends_on "sdl" => :optional

  conflicts_with "coreutils", :because => "both install `gcut` binaries"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-docs
      --without-jasper
      --without-umfpack
    ]

    args << "--without-cairo" if build.without? "cairo"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gegl.h>
      gint main(gint argc, gchar **argv) {
        gegl_init(&argc, &argv);
        GeglNode *gegl = gegl_node_new ();
        gegl_exit();
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/gegl-0.3", "-L#{lib}", "-lgegl-0.3",
           "-I#{Formula["babl"].opt_include}/babl-0.1",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-L#{Formula["glib"].opt_lib}", "-lgobject-2.0", "-lglib-2.0",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
