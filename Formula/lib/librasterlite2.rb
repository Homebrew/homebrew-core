class Librasterlite2 < Formula
  desc "Library to store and retrieve huge raster coverages"
  homepage "https://www.gaia-gis.it/fossil/librasterlite2/index"
  url "https://www.gaia-gis.it/gaia-sins/librasterlite2-sources/librasterlite2-1.1.0-beta1.tar.gz"
  sha256 "f7284cdfc07ad343a314e4878df0300874b0145d9d331b063b096b482e7e44f4"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 4

  livecheck do
    url :homepage
    regex(/href=.*?librasterlite2[._-]v?(\d+(?:\.\d+)+[^.]*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "1c3ebad3c0e8d461961ff6e1ea785d762a411493caa8dc0df62f85cc2fd039d8"
    sha256 cellar: :any,                 arm64_sonoma:   "d31a806dc93f565780c5704c3d4ac4d4925f02f3682a1638ee85f384470ceae3"
    sha256 cellar: :any,                 arm64_ventura:  "594f332c68d15b51bb405623131a630fa528693ee21f2f220d3220bc280fd2dc"
    sha256 cellar: :any,                 arm64_monterey: "3733644a6d712a0be663b99b9b153cba11d05cfb34dc5c207fab8df8a4077a56"
    sha256 cellar: :any,                 arm64_big_sur:  "6bbd6b88f06188a5009e8d451c6f3898e2df630131f5c68953528863a06e9ec2"
    sha256 cellar: :any,                 sonoma:         "d96d40ff1a70980b217bf88a930594175b3b4d4b2f8b308d3978337c31abab39"
    sha256 cellar: :any,                 ventura:        "385aeaee7f4a7e565b6368e2577a73ba58f75d7161bbbe480cc1a6eebc12552f"
    sha256 cellar: :any,                 monterey:       "fcc1aba7b865bd46d2986e77c9d9bf3d8dca6641b9c9fb7ebbbeca409692153e"
    sha256 cellar: :any,                 big_sur:        "642c88a5013468fbc96058720beadc6f6aacbb3a47b60530c434b9df4081aa86"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4fe6861c1f7886a5bdf6cc9782613e8182704503fed2ffb1e088ea08e7081ea3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e91e0eafa3ab9941d7e7b9610089e8398b3259e40951711bc9a70f34c76d0e9"
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
