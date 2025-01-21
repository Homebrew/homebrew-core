class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.45/libpng-1.6.45.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.45/libpng-1.6.45.tar.xz"
  sha256 "926485350139ffb51ef69760db35f78846c805fef3d59bfdcb2fba704663f370"
  license "libpng-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2d9fddec7ff85ea205bf37bcba29116f37b581da9eb90c5bb8beda489f7d6105"
    sha256 cellar: :any,                 arm64_sonoma:  "ceae05fe7def37733cece3f2e459a06ca2dd11b13a70fbd0cc024e3839f743a4"
    sha256 cellar: :any,                 arm64_ventura: "b5d796dfbbc23b292221eb2d5b561bb916d1994c90f788e9049ffe32ef5d27f9"
    sha256 cellar: :any,                 sonoma:        "c296b3b866794ded0c5f87964ebe637ad8904d04c45972f1a1867afd4b37e289"
    sha256 cellar: :any,                 ventura:       "0a59a94ee138a9903a2cf0f7a06b448d267647f245dec672ae56c92d27fd6951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d313004e4148066ac5c5f78cd7aafa15737103d8ec59297e8fed2c5c417755d"
  end

  head do
    url "https://github.com/glennrp/libpng.git", branch: "libpng16"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "test"
    system "make", "install"

    # Avoid rebuilds of dependants that hardcode this path.
    inreplace lib/"pkgconfig/libpng.pc", prefix, opt_prefix
  end

  test do
    (testpath/"test.c").write <<~C
      #include <png.h>

      int main()
      {
        png_structp png_ptr;
        png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
        png_destroy_write_struct(&png_ptr, (png_infopp)NULL);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpng", "-o", "test"
    system "./test"
  end
end
