class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "https://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.4/gegl-0.4.72.tar.xz"
  sha256 "ccbb8cdd1db56ecd4ece5dbabae0118ab2c46b5b3439c94f3cec467798ce956d"
  license all_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later", "BSD-3-Clause", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gegl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/gegl/0.4/"
    regex(/href=.*?gegl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "09bde0ede75cace03ec6d2365358d7a801dcaaa53c75decc4510809b2ded3e76"
    sha256 arm64_tahoe:       "ec9ce003ad62cd27ee15e3a5ce94ce04484965f6e2081899ab187030307a17a7"
    sha256 arm64_sequoia:     "6c2ebf4c201aff4e8b6d0d0d75ec93eac13f36900654ac4e3238609529908f8c"
    sha256 arm64_sonoma:      "40a57e9cb75ce703824e3513dcc51e668c319a36a3f2b7eb65b39bac624c9d5d"
    sha256 arm64_linux:       "d7d7654da633cd03a65419971bdef487c50d8f31f694a4e0b00c5672ce67e28a"
    sha256 x86_64_linux:      "d7871949de55d05b400b7565eb78fdd8c8424128a7484272c5c8235bdc7de987"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "babl"
  depends_on "cairo"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "json-glib"
  depends_on "libnsgif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "webp"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "poppler"
  end

  def install
    args = %w[
      -Ddocs=false
      -Djasper=disabled
      -Dumfpack=disabled
      -Dlibspiro=disabled
      --force-fallback-for=poly2tri-c
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

    flags = shell_output("pkgconf --cflags --libs gegl-#{version.major_minor}").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
