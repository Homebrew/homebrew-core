class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "https://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.4/gegl-0.4.48.tar.xz"
  sha256 "418c26d94be8805d7d98f6de0c6825ca26bd74fcacb6c188da47533d9ee28247"
  license all_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later", "BSD-3-Clause", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gegl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/gegl/0.4/"
    regex(/href=.*?gegl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "b8029fddea32bc65621fd721116b571569346114f1b935da5bd8bc87ab5e7eb7"
    sha256 arm64_sonoma:   "181d5c65f56537c5ba402862e6d2e63d83a02f4e02b5b2bc07482cdfba10ada6"
    sha256 arm64_ventura:  "3ec4319427d9749b83a3dc282465dfe99ca49e91d041ea04ba8b664a7524481b"
    sha256 arm64_monterey: "9eb503e902a884dcc7b9c436183a38080d49093705aeaf852bb468824b590e9b"
    sha256 sonoma:         "bfdeaeaaadabb0a02589256a47ecf8a112bf50a6b4391be319a6b1108db2955e"
    sha256 ventura:        "9e35612d5ba6b7b14aeb6dae97fc6ab3ebd298c68d77cd416426a3ce1c4c6ff3"
    sha256 monterey:       "6ef9068062d0a3d937cc9ecd6dde04d916f535501ed9309d688fca2133920625"
    sha256 x86_64_linux:   "4411ccbe1d5e15a856bec20d3da20a381f97a0ec6950fd906475f7bc26b64bb5"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "babl"
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

    args = %w[
      -Ddocs=false
      -Dcairo=disabled
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
