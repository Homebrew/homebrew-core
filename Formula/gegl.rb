class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "http://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.3/gegl-0.3.30.tar.bz2"
  sha256 "f8b4a93ad2c5187efcc7d9a665ef626a362587eb701eebccf21b13616791e551"

  bottle do
    sha256 "ae7aee421b576b7273c11ec644611de2cbf29c48830881502bab820a38ad0ae3" => :high_sierra
    sha256 "cd00252b0c76457cd60816a357508c6d6fbc5eac0c668e1020e557be2e70bd6f" => :sierra
    sha256 "9a923df101c892ae9862f5266de201fc828e95dc5245f6efed1403cb6241463e" => :el_capitan
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
