class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "https://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.4/gegl-0.4.58.tar.xz"
  sha256 "d5678bbd5fe535941b82f965b97fcc9385ce936f70c982bd565a53d5519d1bff"
  license all_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later", "BSD-3-Clause", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gegl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/gegl/0.4/"
    regex(/href=.*?gegl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "e1f6c6ddb1c9da615b91164dbe664ccf4d4980a375ff8cd4d727fc56265052f7"
    sha256 arm64_sonoma:  "69edb72cd4cef5a11f8df80ed330a2655ce69a1581fb4039ba751a7e0669cb88"
    sha256 arm64_ventura: "ea70d43b88bf85c0e49bdac8179a80a4d32baaaedf12acddead7600d432c7160"
    sha256 sonoma:        "22529927ffc6fcab1be508078bcada7f39a313c6e2339ef11697437132716e48"
    sha256 ventura:       "de5c3a9b0d64cab82d594b8a26bfbc86ea876fc7756accd1f71ccb2a473e4c64"
    sha256 arm64_linux:   "e817a645f790147852d2c89c753c3bbe278a03c07a19b52a2807aa0f8dbc9b6d"
    sha256 x86_64_linux:  "6c279ea6e4337b172e768a6adc2d540cae229a0c5b67e1293b3c2f1272360c2c"
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
