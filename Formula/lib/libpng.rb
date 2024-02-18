class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.42/libpng-1.6.42.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.42/libpng-1.6.42.tar.xz"
  sha256 "c919dbc11f4c03b05aba3f8884d8eb7adfe3572ad228af972bb60057bdb48450"
  license "libpng-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "47979a2dc1df14b4c308ca0b63c0b96e3a96bfcdde341e1933af71d954cee742"
    sha256 cellar: :any,                 arm64_ventura:  "ca4b2ad388b0029166b71ee442ddb8a23de879aaa2bd7d00273c515278c34378"
    sha256 cellar: :any,                 arm64_monterey: "5cb653c66465f7ae3b311671fc347a3d1d0fcb064e16a4d1b370aa7327fb45d7"
    sha256 cellar: :any,                 sonoma:         "124970ed2c924c2e8b25649cda170295600e9b06d8863f5506ca2fefdccad6fd"
    sha256 cellar: :any,                 ventura:        "cb7ac963df8a5e6d1de575bc970a3d9b1fdc0a03f46101d676025d942c4d4584"
    sha256 cellar: :any,                 monterey:       "d77d3a452d4399b24d83d03c7f20a1d2cc7b01858b80b05791b1f0ea7541e75a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a69b84107aeb8979f5694aa5e0680f86c878a9849bf832c43d9cbfe429891ca6"
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
