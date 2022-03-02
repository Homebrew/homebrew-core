class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "https://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.4/gegl-0.4.36.tar.xz"
  sha256 "6fd58a0cdcc7702258adaeffb573a389228ae8f0eff47578efda2309b61b2ca6"
  license all_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later", "BSD-3-Clause", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gegl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/gegl/0.4/"
    regex(/href=.*?gegl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "0f2b1e9e751f1b2ca5b7a04cd596d0c9519958f2ebdce7f96f41067d002346d6"
    sha256 monterey:      "a8b18e980abb9dd1fdf0652db218e46a5afc9d5b13be343b3df1117300b7bd71"
    sha256 big_sur:       "52a33d9e16e603c48f600ca9ce4ba681caba76b247d37e8151a4d3bbfc452a91"
    sha256 catalina:      "c9be0db0d79af3269a54203cc23870bc9dd6ad8c51fc0d6bc0fde4cf33e5c9a4"
    sha256 x86_64_linux:  "4de825248e9f3448382f5de5c622200c3d9d3f8bece7c8e8f3f1b1303f222cca"
  end

  depends_on "glib" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "babl"
  depends_on "gettext"
  depends_on "glib"
  depends_on "jpeg"
  depends_on "json-glib"
  depends_on "libpng"

  on_linux do
    depends_on "cairo"
  end

  conflicts_with "coreutils", because: "both install `gcut` binaries"

  def install
    args = std_meson_args + %w[
      -Ddocs=false
      -Dcairo=disabled
      -Djasper=disabled
      -Dumfpack=disabled
      -Dlibspiro=disabled
      --force-fallback-for=libnsgif,poly2tri-c
    ]

    ### Temporary Fix ###
    # Temporary fix for a meson bug
    # Upstream appears to still be deciding on a permanent fix
    # See: https://gitlab.gnome.org/GNOME/gegl/-/issues/214
    inreplace "subprojects/poly2tri-c/meson.build",
      "libpoly2tri_c = static_library('poly2tri-c',",
      "libpoly2tri_c = static_library('poly2tri-c', 'EMPTYFILE.c',"
    touch "subprojects/poly2tri-c/EMPTYFILE.c"
    ### END Temporary Fix ###

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
