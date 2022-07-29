class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "https://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.4/gegl-0.4.38.tar.xz"
  sha256 "e4a33c8430a5042fba8439b595348e71870f0d95fbf885ff553f9020c1bed750"
  license all_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later", "BSD-3-Clause", "MIT"]
  revision 1
  head "https://gitlab.gnome.org/GNOME/gegl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/gegl/0.4/"
    regex(/href=.*?gegl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "e3b8f3e5feaf9c697262e1b1469424f29e211a2f32143f8c6726e5b4eba6e917"
    sha256 arm64_big_sur:  "d960f0db802df919fab8370732d106bdfe7ff48f3ca9bd97825b86a43a9c898e"
    sha256 monterey:       "a009fb78d8f660473b439434a5a63bf19b00de4f5397bfd013fc26373c0bf212"
    sha256 big_sur:        "43fd908bb5129152caf51a455d7ec666f8f5b4bcb7db216c5957958931f2bd8d"
    sha256 catalina:       "59a7117dc1a029a5e24904f9f40319b53d1c200a41df0a54df53e8da78b2ad60"
    sha256 x86_64_linux:   "9d82f54188b03437bf8db9c8cdf8be55fde5cdac6cc358e3ea9245212e7933a6"
  end

  depends_on "glib-utils" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "babl"
  depends_on "gettext"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "json-glib"
  depends_on "libpng"

  on_linux do
    depends_on "cairo"
  end

  conflicts_with "coreutils", because: "both install `gcut` binaries"

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
