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
    sha256 cellar: :any,                 arm64_tahoe:   "18e0856e87350a08712e11c4ddc9e52eb4c2ece8b86a6db548cc83a148fdd186"
    sha256 cellar: :any,                 arm64_sequoia: "dcf7667dca29bd93d161da5d96fa3aa08f36720c0be22878efea3d6c2a694bf6"
    sha256 cellar: :any,                 arm64_sonoma:  "0d04e1f9c6b9c23d523bedb24213f98bdcd9a5828b75f28713eb7ac2b55178e0"
    sha256 cellar: :any,                 sonoma:        "116ff03e7185ddd86a47605e9b26f880bf3afbbc83760066082b0d9097670f3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b594f20544f78f0788c1b6ee9f7ad74e528b784fa7e9a825c3e9097145f5c9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a799bb515d1bf6ee8165fdf02a0db2ba0999419667b730af7d9f00c949947a7"
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
  uses_from_macos "zlib"

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
