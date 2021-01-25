class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "https://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.4/gegl-0.4.28.tar.xz"
  sha256 "1d110d8577d54cca3b34239315bd37c57ccb27dd4355655074a2d2b3fd897900"
  license all_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later", "BSD-3-Clause", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gegl.git"

  livecheck do
    url "https://download.gimp.org/pub/gegl/0.4/"
    regex(/href=.*?gegl[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "859bd53d054e26fcfa4dd3aa9a66a7d6c5227df0e86c4c4b7ee4f2941b04b13c" => :big_sur
    sha256 "4bac67fd6373cdfa8b8d733146b66ec8d8250133468bef537188486c8f6a29d4" => :arm64_big_sur
    sha256 "e9e37ccb4f1704c03acad379e62c33fb022edb93340d34f75c07e965b5396f39" => :catalina
    sha256 "eb0a0d104a4654a73ab1a4c109afbe4f2b4c10f340d9df7b54e5f175446df455" => :mojave
  end

  depends_on "glib" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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
      -Dwith-docs=false
      -Dwith-cairo=false
      -Dwith-jasper=false
      -Dwith-umfpack=false
      -Dwith-libspiro=false
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
    system ENV.cc, "-I#{include}/gegl-0.4", "-L#{lib}", "-lgegl-0.4",
           "-I#{Formula["babl"].opt_include}/babl-0.1",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-L#{Formula["glib"].opt_lib}", "-lgobject-2.0", "-lglib-2.0",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
