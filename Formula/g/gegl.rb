class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "https://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.4/gegl-0.4.46.tar.xz"
  sha256 "d0b3b2481bc8774c5f3d0a487611910166d18eef823a859fb91e781ab7b1e892"
  license all_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later", "BSD-3-Clause", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gegl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/gegl/0.4/"
    regex(/href=.*?gegl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "1af4fac0e4faedecc925fd8467e9739fd37c4ca0ebe0a96f270214263ae7fba3"
    sha256 arm64_ventura:  "70e73227ab3babf88c3b92a755c4077eac31e59cf894eb2ba56d7b85ce8da046"
    sha256 arm64_monterey: "8e05cf9e7284b79287d42375a3ad0deb0297062082fb7535aa17022399fb65cd"
    sha256 arm64_big_sur:  "0676101111c243167d9826e3d0d2b1ce896469459e8210530b804d2603218253"
    sha256 sonoma:         "b1c46a61a0611568aaa45213a95e486383cf973660642712af89eaaa003d7936"
    sha256 ventura:        "004b97b7d7b24739a87565265dadb12dfa06c35ab23b6fa2447d4aa4a4307432"
    sha256 monterey:       "c9528587fa729a1205b6fa8e255832c31078fb1048e615e71542420bc5be2e36"
    sha256 big_sur:        "d3b1dc1229ce6306c8ae0c88fd2f1a17c832ce071c9375750025f577d4892a46"
    sha256 x86_64_linux:   "886706bdf73a47733567e36d8d10abbf3627278be026dcc7e66f44b4f1e444df"
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
    depends_on "poppler"
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
