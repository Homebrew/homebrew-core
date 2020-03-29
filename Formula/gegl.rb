class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "http://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.4/gegl-0.4.16.tar.bz2"
  sha256 "0112df690301d9eb993cc48965fc71b7751c9021a4f4ee08fcae366c326b5e5a"
  revision 3

  bottle do
    sha256 "d41ef22ba4c1dd583d3b18c305d8d132fa3db3d51da3a83df1824aff4db589ca" => :catalina
    sha256 "3d0ff52bcb2583817c2c37d052e693e6f3477e18ae3f11d92655d56f19a7c8b9" => :mojave
    sha256 "0c8cdd38e69be4850198711e93a99d6b524fd04ef1efc577b1f55c687e406834" => :high_sierra
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
                          "--without-umfpack",
                          "--without-libspiro"
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
