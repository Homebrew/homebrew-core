class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "http://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.3/gegl-0.3.10.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/g/gegl/gegl_0.3.10.orig.tar.bz2"
  sha256 "26b4d6d0a8edb358ca2fbc097f9f97eec9d74e0ffe42f89fa1aff201728023d9"

  bottle do
    sha256 "bbd227d4b5387e4a2531ba9f832230ea1101c0bc28d8dacabdc230f5c1f60b3a" => :sierra
    sha256 "1f66b826e5c277f955fc1d57ea0d742c362e7b1f7ba89622807f34c83c449574" => :el_capitan
    sha256 "c034ab5704fc55d27fd07fb8576ed3478a595c44809eadf226f35751c949696d" => :yosemite
  end

  head do
    # Use the Github mirror because official git unreliable.
    url "https://github.com/GNOME/gegl.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "babl"
  depends_on "gettext"
  depends_on "glib"
  depends_on "json-glib"
  depends_on "libpng"
  depends_on "jpeg"
  depends_on "cairo" => :optional
  depends_on "librsvg" => :optional
  depends_on "lua" => :optional
  depends_on "pango" => :optional
  depends_on "sdl" => :optional

  def install
    # ./configure breaks when optimization is enabled with llvm
    ENV.no_optimization if ENV.compiler == :llvm

    argv = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-docs
    ]

    if build.universal?
      ENV.universal_binary
      # ffmpeg's formula is currently not universal-enabled
      argv << "--without-libavformat"

      opoo "Compilation may fail at gegl-cpuaccel.c using gcc for a universal build" if ENV.compiler == :gcc
    end

    system "./autogen.sh" if build.head?
    system "./configure", *argv
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
