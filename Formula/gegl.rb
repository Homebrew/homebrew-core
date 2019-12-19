class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "http://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.4/gegl-0.4.18.tar.xz"
  sha256 "c946dfb45beb7fe0fb95b89a25395b449eda2b205ba3e8a1ffb1ef992d9eca64"

  bottle do
    sha256 "c85c022cbec147dc1c206c6efaaab0ad1cc9db52b90706a3e131b6918eed7f89" => :catalina
    sha256 "9a94a1bfa65fc2aab0076a2dc5bdd8f78607c735b6043c5ce8d9aad192e9818f" => :mojave
    sha256 "b12c213159d53df0bf6777fb81d13bb93ba90683da3142bb38d250d7dfc00d05" => :high_sierra
    sha256 "22fd034b398955586ff07868178a930858d428e1af957c1921260ff679fea672" => :sierra
  end

  head do
    # Use the Github mirror because official git unreliable.
    url "https://github.com/GNOME/gegl.git"

    depends_on "libtool" => :build
  end

  depends_on "cmake" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build

  depends_on "pkg-config" => :build
  depends_on "babl"
  depends_on "gettext"
  depends_on "glib"
  depends_on "jpeg"
  depends_on "json-glib"
  depends_on "libpng"
  depends_on "little-cms2"

  conflicts_with "coreutils", :because => "both install `gcut` binaries"

  def install
    system "meson", "build", "--prefix=#{prefix}"
    cd "build" do
      system "ninja"
      system "ninja", "install"
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
