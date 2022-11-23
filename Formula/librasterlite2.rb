class Librasterlite2 < Formula
  desc "Library to store and retrieve huge raster coverages"
  homepage "https://www.gaia-gis.it/fossil/librasterlite2/index"
  url "https://www.gaia-gis.it/gaia-sins/librasterlite2-sources/librasterlite2-1.1.0-beta1.tar.gz"
  sha256 "f7284cdfc07ad343a314e4878df0300874b0145d9d331b063b096b482e7e44f4"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?librasterlite2[._-]v?(\d+(?:\.\d+)+[^.]*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f44af8912d6461e2d7400b5aa79779f52e1801afacdd01104e36314145ec094f"
    sha256 cellar: :any,                 arm64_monterey: "465fa76b41fa9b5bb74ac5e1cb685cb257ebcd0afc977f1d5c80b0b5a4fd36ff"
    sha256 cellar: :any,                 arm64_big_sur:  "0b52c403552843c1d62c669a06ffc7db142ccc07d4455c2a3b06005011e1c601"
    sha256 cellar: :any,                 ventura:        "08c84cce7d03471e4da153554f785fcb0fbb5ff2f7a4ffa5eb57798d0a135512"
    sha256 cellar: :any,                 monterey:       "862aaa43b27513049a7c800339b7359cbf0b353bf4aefe80e73b2cc1c05bedc5"
    sha256 cellar: :any,                 big_sur:        "ae5159a279a6095c933e56b9473dbb8d0dfb4a7c3a289b046b02f89160abb14f"
    sha256 cellar: :any,                 catalina:       "ac48019369d22607d83ba59dff181ab243386eeb30c83f0fe945853ae98610cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57ca97b282a779c6260f64cd65db5d017ad6fca6e2c2971fe88743614c614b16"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "freexl"
  depends_on "geos"
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libgeotiff"
  depends_on "libpng"
  depends_on "librttopo"
  depends_on "libspatialite"
  depends_on "libtiff"
  depends_on "lz4"
  depends_on "minizip"
  depends_on "openjpeg"
  depends_on "pixman"
  depends_on "proj"
  depends_on "sqlite"
  depends_on "webp"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    # Reported upstream at https://www.gaia-gis.it/fossil/librasterlite2/tktview?name=3e9183941f.
    # Check if this can be removed with the next release.
    inreplace "headers/rasterlite2_private.h",
              "#ifndef DOXYGEN_SHOULD_SKIP_THIS",
              "#include <time.h>\n\n#ifndef DOXYGEN_SHOULD_SKIP_THIS"

    # Ensure Homebrew SQLite libraries are found before the system SQLite
    ENV.append "LDFLAGS", "-L#{Formula["sqlite"].opt_lib} -lsqlite3"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <unistd.h>
      #include <stdio.h>

      #include "rasterlite2/rasterlite2.h"

      static int
      test_gif (const char *path)
      {
          rl2SectionPtr img = rl2_section_from_gif (path);
          if (img == NULL)
            {
            fprintf (stderr, "Unable to read: %s\\n", path);
            return 0;
            }

          if (rl2_section_to_png (img, "./from_gif.png") != RL2_OK)
            {
            fprintf (stderr, "Unable to write: from_gif.png\\n");
            return 0;
            }

          rl2_destroy_section (img);
          return 1;
      }

      int
      main (int argc, char *argv[])
      {
          if (argc > 1 || argv[0] == NULL)
          argc = 1;		/* silence compiler warnings */

          if (!test_gif ("#{test_fixtures("test.gif")}"))
          return -1;

          return 0;
      }
    EOS

    pkg_config_flags = shell_output("pkg-config --cflags --libs rasterlite2").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-o", "test"
    system testpath/"test"
    assert_predicate testpath/"from_gif.png", :exist?
  end
end
