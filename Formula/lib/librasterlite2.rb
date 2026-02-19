class Librasterlite2 < Formula
  desc "Library to store and retrieve huge raster coverages"
  homepage "https://www.gaia-gis.it/fossil/librasterlite2/index"
  url "https://www.gaia-gis.it/gaia-sins/librasterlite2-sources/librasterlite2-1.1.0-beta1.tar.gz"
  sha256 "f7284cdfc07ad343a314e4878df0300874b0145d9d331b063b096b482e7e44f4"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 5

  livecheck do
    url :homepage
    regex(/href=.*?librasterlite2[._-]v?(\d+(?:\.\d+)+[^.]*?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "aedae0439b69ea9c2e069dd3d4cb868db71deb9e953806354bd57ea476f4698c"
    sha256 cellar: :any,                 arm64_sequoia: "f02cc5381292362b7128c25c0ece3cbcbba43ef9fd0e61afa994eb22044032f0"
    sha256 cellar: :any,                 arm64_sonoma:  "3d3f1875ddad0758159259e6608f6f170064ad474ba4912aad480c117fed161e"
    sha256 cellar: :any,                 sonoma:        "431c45dd52bc4491321fdd17e420cfcab8c70e0854873aee1104f2296177a792"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "778b21f4a0da7c8f5bce15877479198bb03cb37c81b9682af06907773178bce8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaacb56f12774ee2064e0993afad66d2bce90846b22d834bfd91ecff2b61bd6a"
  end

  depends_on "pkgconf" => [:build, :test]
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
  depends_on "libxml2"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
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
    (testpath/"test.c").write <<~C
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
    C

    flags = shell_output("pkgconf --cflags --libs rasterlite2").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system testpath/"test"
    assert_path_exists testpath/"from_gif.png"
  end
end
