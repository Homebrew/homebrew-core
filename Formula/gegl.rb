class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "http://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.4/gegl-0.4.24.tar.xz"
  sha256 "7765499f27341b0d16032e665319cbc12876483ff6a944fcdf24a9c58e3e254a"

  bottle do
    sha256 "2067ee4af3b1ddc40a49765e5612bcd23f0724ce2702db200f2ed7fc28792df5" => :catalina
    sha256 "8163a17103afaaaadfaee1e509847278929365b4a8aac049f5912536e6b8b169" => :mojave
    sha256 "35b5da2793a47b04b659a152e33dd520d28dfd42e9267288c28a0898d4098a3b" => :high_sierra
  end

  head do
    # Use the Github mirror because official git unreliable.
    url "https://github.com/GNOME/gegl.git"
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

  conflicts_with "coreutils", :because => "both install `gcut` binaries"

  def install
    args = std_meson_args + %w[
      -Dwith-docs=false
      -Dwith-cairo=false
      -Dwith-jasper=false
      -Dwith-umfpack=false
      -Dwith-libspiro=false
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
