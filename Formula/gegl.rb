class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "http://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.4/gegl-0.4.12.tar.bz2"
  sha256 "e967293eabe89257e1d511bf68435fbfd44e6e0f9ef51b86cc50781f09eb5852"

  bottle do
    sha256 "ac42f2a90467b4f7dbbbfb97a22d5a732c8f1533a5dc9c7e210bb72bbbf90038" => :mojave
    sha256 "ed9407e3b8786f1840bde01d52a0c590b4a2a9c3ca0f4b91070a7ccdc7320f2f" => :high_sierra
    sha256 "acd3639be39b4ab8c32e1045fe1da34ba6a9ed2629f088f6e77d591aa434bf7a" => :sierra
    sha256 "b750b42ab0c76b316bfe9e247764d5c6a1fdb47584c9408a1e989c0d2b0ce850" => :el_capitan
  end

  head do
    # Use the Github mirror because official git unreliable.
    url "https://github.com/GNOME/gegl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
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

  conflicts_with "coreutils", :because => "both install `gcut` binaries"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-docs",
                          "--without-cairo",
                          "--without-jasper",
                          "--without-umfpack"
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
