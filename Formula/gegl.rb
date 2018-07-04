class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "http://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.4/gegl-0.4.4.tar.bz2"
  sha256 "f8cb45da736131fe29582b74cf6851102ae013bf99c77413a8bcb02e92e57890"

  bottle do
    sha256 "05ceb7cbb0e4e78b38401098e194337fe4f182725e8151ed5325ebae66f8d652" => :high_sierra
    sha256 "a303283091b90f28bbdf59faa6b0bc381d693dd4039255d4e2762125d293954e" => :sierra
    sha256 "ccae05349e59c5e59e99692135aeaef48aada334e6fa9bcb624201d48240512a" => :el_capitan
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
    system ENV.cc, "-I#{include}/gegl-0.4", "-L#{lib}", "-lgegl-0.4",
           "-I#{Formula["babl"].opt_include}/babl-0.1",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-L#{Formula["glib"].opt_lib}", "-lgobject-2.0", "-lglib-2.0",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
