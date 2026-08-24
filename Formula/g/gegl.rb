class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "https://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.4/gegl-0.4.70.tar.xz"
  sha256 "47f50d9c3aecd375deb48c11ebfead52d162e4fc162a4b3d44618277f1faec02"
  license all_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later", "BSD-3-Clause", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gegl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/gegl/0.4/"
    regex(/href=.*?gegl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "2b7db4e2336469f3fc76e64357a2fad4af290886e4fb593f6e8fc605948db2d3"
    sha256 arm64_sequoia: "1e167377455475816941f959b78e9e98675b9d7a0977cb13ab1a38881270b47f"
    sha256 arm64_sonoma:  "38ac50dae75b8294e2c4c52bcc95234e3c4764055afbde61d91bdcdef99b147d"
    sha256 sonoma:        "d5e6f2633c1e1b5c0cb170cf76331c30081198d7646c284b8a1865939086b0ac"
    sha256 arm64_linux:   "07c9a5de190d526c608329587b9ccb7fde8b1428d19d47ac46535c84b54fc1a3"
    sha256 x86_64_linux:  "53356701f9f23303c29f2861651c50c69ae41e8a1c68db861af364389f4f8d5a"
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
