class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.49/libpng-1.6.49.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.49/libpng-1.6.49.tar.xz"
  sha256 "43182aa48e39d64b1ab4ec6b71ab3e910b67eed3a0fff3777cf8cf40d6ef7024"
  license "libpng-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9cbe6dd4dedf8f7860b48ba1f42dbd5130af838aa15444d02781b1335861d7a6"
    sha256 cellar: :any,                 arm64_sonoma:  "ebc3041009f8109957420f98481d514407ae78213ab6d710e736221d31e9ce91"
    sha256 cellar: :any,                 arm64_ventura: "92a708784c36c6c63ff514690516a1071a4e27b57e6da680e422c91108ccbd34"
    sha256 cellar: :any,                 sonoma:        "bc858e121e0cd6049ec041b36d241542e90a23fc1749423193b20f573b57afed"
    sha256 cellar: :any,                 ventura:       "cc1241c31c873bc8451845e1a73588e0ee74828c5128eb93e799b50e7f2e0517"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0324945acef84abba7a44c41149e86db7bc6af962ff6b86bbe79a9feec194c4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a8c105cea25bdaf70e123d60dd7322e061045ee33f63a1f330aa3d1ce5880fa"
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
