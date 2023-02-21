class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "https://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.4/gegl-0.4.42.tar.xz"
  sha256 "aba83a0cbaa6c56edc29ea22f2e8172950a53b96daa51592083d59222bdde02d"
  license all_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later", "BSD-3-Clause", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gegl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/gegl/0.4/"
    regex(/href=.*?gegl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "ddee658a85cb1891dd4c6ae10b40a7e4c68922eac49777dd165362fc93b3bffa"
    sha256 arm64_monterey: "91bb8f33c1700d9c45f906cee3854e7dfbc24fc2b42b2b0c0c161884f7d3c902"
    sha256 arm64_big_sur:  "ef0f3b155ba34c48daeac9b302af952004aefe40a088ffd86490bf1366a6e7bf"
    sha256 ventura:        "49e264a36a9b996b9710b7cd005d51512df61797676ffa302cbd3bae65142bba"
    sha256 monterey:       "31d3ae63442125320cf3c99a8541f3e4be97baba6b694e64efb4c257bdb6750f"
    sha256 big_sur:        "1761f7e677647fab54583b4bd272c999e5432703f575ad3dbf608d3088500808"
    sha256 x86_64_linux:   "e0fea30f49b22c7aac70841a860c9b1e66bab14e4355147c2ab98e7019e05638"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "babl"
  depends_on "gettext"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "json-glib"
  depends_on "libpng"

  on_linux do
    depends_on "cairo"
  end

  def install
    ### Temporary Fix ###
    # Temporary fix for a meson bug
    # Upstream appears to still be deciding on a permanent fix
    # See: https://gitlab.gnome.org/GNOME/gegl/-/issues/214
    inreplace "subprojects/poly2tri-c/meson.build",
      "libpoly2tri_c = static_library('poly2tri-c',",
      "libpoly2tri_c = static_library('poly2tri-c', 'EMPTYFILE.c',"
    touch "subprojects/poly2tri-c/EMPTYFILE.c"
    ### END Temporary Fix ###

    system "meson", *std_meson_args, "build",
                    "-Ddocs=false",
                    "-Dcairo=disabled",
                    "-Djasper=disabled",
                    "-Dumfpack=disabled",
                    "-Dlibspiro=disabled",
                    "--force-fallback-for=libnsgif,poly2tri-c"
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
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
    system ENV.cc,
           "-I#{Formula["babl"].opt_include}/babl-0.1",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-L#{Formula["glib"].opt_lib}", "-lgobject-2.0", "-lglib-2.0",
           testpath/"test.c",
           "-I#{include}/gegl-0.4", "-L#{lib}", "-lgegl-0.4",
           "-o", testpath/"test"
    system "./test"
  end
end
