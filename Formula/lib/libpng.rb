class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.46/libpng-1.6.46.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.46/libpng-1.6.46.tar.xz"
  sha256 "f3aa8b7003998ab92a4e9906c18d19853e999f9d3bca9bd1668f54fa81707cb1"
  license "libpng-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "611e6044865656846804200a1fd64c1a2d509b9475a83cb9251f8947ed972b5b"
    sha256 cellar: :any,                 arm64_sonoma:  "5a44a2e8483ea80c3c785d817571885b1fd69796d50c9fde219000db0ba3b0fc"
    sha256 cellar: :any,                 arm64_ventura: "c780af18d0dacace83df8ee015e9c01caa9f158f94d7a9a4090d6b07cb31633a"
    sha256 cellar: :any,                 sonoma:        "34fde4703af6d8af9f765843eef9d3f6b3e6cd9575e77b9056c4748e7d5e26c8"
    sha256 cellar: :any,                 ventura:       "0c6a41266b6f59ee539b7b60d763d3b9fadad6d0e9621ea1512bd1bfd85b48a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c282107afe3641f96eeecfec0cab9160ea429d03534a708e1efd1f7d87c4397c"
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
