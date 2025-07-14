class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "https://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.4/gegl-0.4.62.tar.xz"
  sha256 "5887576371ebf1d9e90797d10e4b9a7f1658228d4827583e79e1db3d94505c6c"
  license all_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later", "BSD-3-Clause", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gegl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/gegl/0.4/"
    regex(/href=.*?gegl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "f7272f324876d8ca55b210402e3bb91ff5c9f10737802f722975b933f5161c36"
    sha256 arm64_sonoma:  "986333c8e8ebe1975273ac8f399884e284e51491bc6cfa06fb000f38db46fe27"
    sha256 arm64_ventura: "409cae15ff790645758161608ffd49d272a8f78a84f0ba5ca789cb95bf45ed6d"
    sha256 sonoma:        "8bd1bdb50dcb15a99b52d0ae0853eee3a16ba9c32ba018c70c6636e6869ddb60"
    sha256 ventura:       "35ea68ae5c2e81be99e64aca0d0fa634d59fd0bfd76d3c68d21265246b435127"
    sha256 arm64_linux:   "ead3747c178ec15e357985a438a3b9588e4bd8c817faff220c30cc2ac7dfca74"
    sha256 x86_64_linux:  "4a55a0bad96d4bb63b3d7494cc05b1805b92e55020766f2da5061d66d872eed4"
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
