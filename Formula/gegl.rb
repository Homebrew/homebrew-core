class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "http://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.3/gegl-0.3.18.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/g/gegl/gegl_0.3.18.orig.tar.bz2"
  sha256 "d7858ef26ede136d14e3de188a9e9c0de7707061a9fb96d7d615fab4958491fb"
  revision 1

  bottle do
    sha256 "ed94a256f9a8aed06b3d2c904b38f15211027e0588d117c2265030289d92cd73" => :sierra
    sha256 "2372a5814c5d91fd0f5a72dc3d781af645359e179b855261178b40c410e795fb" => :el_capitan
    sha256 "23be0d6afe116bdd2397e681a68bdd9a566a42dc69c5a461e0032571f247c3dc" => :yosemite
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
  depends_on "json-glib"
  depends_on "libpng"
  depends_on "jpeg"
  depends_on "cairo" => :optional
  depends_on "librsvg" => :optional
  depends_on "lua" => :optional
  depends_on "pango" => :optional
  depends_on "sdl" => :optional

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-docs"
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
