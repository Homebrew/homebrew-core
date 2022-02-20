class Librasterlite2 < Formula
  desc "Library to store and retrieve huge raster coverages"
  homepage "https://www.gaia-gis.it/fossil/librasterlite2/index"
  url "https://www.gaia-gis.it/gaia-sins/librasterlite2-sources/librasterlite2-1.1.0-beta1.tar.gz"
  sha256 "f7284cdfc07ad343a314e4878df0300874b0145d9d331b063b096b482e7e44f4"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "954d42bad006a1564d10ef4dab4f01309b561019309d8c1240a57785fa49b56f"
    sha256 cellar: :any,                 arm64_big_sur:  "e75aedb1481b518abe8604322c6cb2eb9d65e41660615109fa0aef0b057993d7"
    sha256 cellar: :any,                 monterey:       "0e88777916b6b91f5e738fd6bf807a0201db1b0301631f09cd46cedd1c070ab5"
    sha256 cellar: :any,                 big_sur:        "794be42718985e2d7af7e329ef9180faad6f50da76c17ef59aefcf7d3a38dd23"
    sha256 cellar: :any,                 catalina:       "85b26685a584ae48bca118ce78369eef1d31510fad29096821ff295d974f38fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83594e1a63cf7024bc281c86141e320c4c6415705f8b2fcc6edabc9ec8ab6f94"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "freexl"
  depends_on "geos"
  depends_on "giflib"
  depends_on "jpeg"
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
    sqlite = Formula["sqlite"]
    ENV.append "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3"
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
