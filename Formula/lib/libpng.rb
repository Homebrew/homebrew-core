class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.48/libpng-1.6.48.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.48/libpng-1.6.48.tar.xz"
  sha256 "46fd06ff37db1db64c0dc288d78a3f5efd23ad9ac41561193f983e20937ece03"
  license "libpng-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a6ca2508569d9237cbb46a2d3da13b9e2e8d9d042ca48b78463f34aa527cd7ce"
    sha256 cellar: :any,                 arm64_sonoma:  "44fc8cfe04fcf2bf39fb2dc479f5b7170fb7a3db23e6fadc5d71ea3eff2ccfa2"
    sha256 cellar: :any,                 arm64_ventura: "0c4e9222ea305c1b20edeb3bfe79cc99098291286a37a0da1f980cd5621d70ba"
    sha256 cellar: :any,                 sonoma:        "0858ad8c30002d9277514223d78a7f52fb04d6f1263c00b66714a74fb9baaf8f"
    sha256 cellar: :any,                 ventura:       "0bcf3cf2bcc9ca53834d5806c9dafc6bc0c2dbebc196b8722e50d6059e5fb92f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdfd8c8ad7b7a8ed8257bc59ee4e05ce7adea9fb04991928efdc681f530b1ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e10fd6235517d48b80f5d7b30271b19264102ff7bfb1fd4bec293e41866db84d"
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
