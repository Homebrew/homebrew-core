class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.39/libpng-1.6.39.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.39/libpng-1.6.39.tar.xz"
  sha256 "1f4696ce70b4ee5f85f1e1623dc1229b210029fa4b7aee573df3e2ba7b036937"
  license "libpng-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5fcb6945c7fe220f8b983c18edd7a42d8d84a9d62696b4fec001c1697300fb61"
    sha256 cellar: :any,                 arm64_monterey: "c437aaaf373f369e94825937854374a0b17bf965c1ba2a0faf22818111372038"
    sha256 cellar: :any,                 arm64_big_sur:  "a19d1b6b4df35819a43ab5def000101bb902fbc85222d548ba9c1964578d41f7"
    sha256 cellar: :any,                 ventura:        "b6a613111f86af2e0e50994f225626f257adbca25e48c3f824ed68340b08bf63"
    sha256 cellar: :any,                 monterey:       "f7217880961411f37b5ba86376f5a6772bf45d1ae98ee86a01677439ce381cc0"
    sha256 cellar: :any,                 big_sur:        "af1e13deeaa14eebacdbfb075e1cf245409cc1e2d2d7991e55b017262648245c"
    sha256 cellar: :any,                 catalina:       "13780286d987167f7e50aea65947e1460a6616d0f1b224b37f8351775eab72f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c5a372a45b230cca6717e4cbfb9f85d4218118028c3961409e09c7cd4b85beb"
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
    (testpath/"test.c").write <<~EOS
      #include <png.h>

      int main()
      {
        png_structp png_ptr;
        png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
        png_destroy_write_struct(&png_ptr, (png_infopp)NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpng", "-o", "test"
    system "./test"
  end
end
