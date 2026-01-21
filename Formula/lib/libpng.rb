class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.54/libpng-1.6.54.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.54/libpng-1.6.54.tar.xz"
  sha256 "01c9d8a303c941ec2c511c14312a3b1d36cedb41e2f5168ccdaa85d53b887805"
  license "libpng-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6dc9b4e6276feaec173ab5c176886d761fe1f463d6d04137d899ab17fbf8b137"
    sha256 cellar: :any,                 arm64_sequoia: "65efb33851b617baeae73a2432f356e4ca7aabb1a3fd41d2b246de962b234562"
    sha256 cellar: :any,                 arm64_sonoma:  "54cc968d700adfcdd439f681c6432bddb696270ce251d3dd37fb7de755582892"
    sha256 cellar: :any,                 sonoma:        "26d76792552523faf584cdcfd592b11ec86f075f62d83b2786c1c60e1dffc0a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dd66d5c4b3b060f9c0a3971a827247a8813cd82514c5da27f12211d4ef8ed27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06b9ba6739b64a9f294a212acf79952b38fc79caaec6d3117654722a70c7a7cb"
  end

  head do
    url "https://github.com/glennrp/libpng.git", branch: "libpng16"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
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
