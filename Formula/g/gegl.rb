class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "https://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.4/gegl-0.4.64.tar.xz"
  sha256 "0de1c9dd22c160d5e4bdfc388d292f03447cca6258541b9a12fed783d0cf7c60"
  license all_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later", "BSD-3-Clause", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gegl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/gegl/0.4/"
    regex(/href=.*?gegl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e6a1c4f04695d04e054e373c265f25ddfe9459a6aa90dd8097895fdc42dc2d28"
    sha256 arm64_sequoia: "9abe8b3082760302923afe041d8792c98977d6a77d41da71e56ed6d24caa27b4"
    sha256 arm64_sonoma:  "c6ed3ae6ba605d7f0afc00b34c7d727bd712b2773df4b15d92f8715248752974"
    sha256 sonoma:        "84a7cc23067200f0b215251d6fcc01456529956604503054a194deaeafe69a67"
    sha256 arm64_linux:   "c3ea7978107c67b085bbb4e64b7116ea4e6d3cf1ae489c1fb2bfe63bf273916b"
    sha256 x86_64_linux:  "c0585d66c3447d9c1e3aa3cb8e6dec27cf41799722068dfa0379bf3a8450597a"
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
