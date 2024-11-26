class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "https://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.4/gegl-0.4.50.tar.xz"
  sha256 "6084969b06ee86ca71142133773f27e13f02e5a6a22c2cfce452ecaaddb790c1"
  license all_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later", "BSD-3-Clause", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gegl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/gegl/0.4/"
    regex(/href=.*?gegl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "747d9f2ff9be71202954ff34a9a1caa0c1ca372e9687c1c9b820be17c56a3b79"
    sha256 arm64_sonoma:  "96ee15eb5e4d61c5b5cda69ac93a1cc18d95818c3fe116715a4a4da3902595ec"
    sha256 arm64_ventura: "db96141fe2b4cf84ee13f313b3c1d565c3b1244b65e89187787f5450ea0dec88"
    sha256 sonoma:        "438589cbdf01a9ee9fa069cdfda4acaf4203c7f37179eef57d7e70522c12fbfa"
    sha256 ventura:       "aac8f70a6fd4e43184c96e841e87305d8b1285be01dacfadc1ebf152c8e50d3b"
    sha256 x86_64_linux:  "c499d23410bf942a333fcda22f0d57ff2e35d66515d703504e464b469c202653"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "babl"
  depends_on "cairo"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "json-glib"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
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

    args = %w[
      -Ddocs=false
      -Djasper=disabled
      -Dumfpack=disabled
      -Dlibspiro=disabled
      --force-fallback-for=libnsgif,poly2tri-c
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gegl.h>
      gint main(gint argc, gchar **argv) {
        gegl_init(&argc, &argv);
        GeglNode *gegl = gegl_node_new ();
        gegl_exit();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test",
                   "-I#{Formula["babl"].opt_include}/babl-0.1",
                   "-I#{Formula["glib"].opt_include}/glib-2.0",
                   "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
                   "-I#{include}/gegl-0.4",
                   "-L#{lib}", "-lgegl-0.4",
                   "-L#{Formula["glib"].opt_lib}", "-lgobject-2.0", "-lglib-2.0"
    system "./test"
  end
end
