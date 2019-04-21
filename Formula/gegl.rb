class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "https://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.4/gegl-0.4.14.tar.bz2"
  sha256 "4c01d58599d8ddb3714effd2675ea1863272cf2d7d9ed3d32aee80c89f859901"

  bottle do
    sha256 "b8332d3d8eebb52fd56aa05855c86b41bc3e927bd3b6dd71d548463a61e50684" => :mojave
    sha256 "123bd45aa0e95f88fd358d658550b1f7ddb2ba67db618a7b211b0de03f998a0d" => :high_sierra
    sha256 "63631fab75456b433df2fb72701265d5a755795ffaa2d9d30034f7cef5426597" => :sierra
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

  # Build support for macOS is missing in 0.4.14, but patches have been pushed to upstream head
  # to fix this. Remove patches in next release.
  patch do
    url "https://gitlab.gnome.org/GNOME/gegl/commit/fe756be6f0c776a45201a61f67d3e5e42f6398de.patch"
    sha256 "70d08b442c038c67ec52954fca0ff4d9f87cbf2a24ec11fd35d050784b93bfde"
  end

  patch do
    url "https://gitlab.gnome.org/GNOME/gegl/commit/ac331b5c0e3d940b64bb811b0f54e86c7d312917.patch"
    sha256 "0bf44d701982e7f7c933b7cc6602f16f639d6ea4b6d35bdf2cfd2dfeaaa12cc2"
  end

  patch do
    url "https://gitlab.gnome.org/GNOME/gegl/commit/d05eb01170728f45f561ca937708a293e29e02d9.patch"
    sha256 "0630d93cfa07620c1a9f157a9ca53a7760518088acbbe58a141160caa528e529"
  end

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
