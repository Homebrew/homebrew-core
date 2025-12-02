class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.51/libpng-1.6.51.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.51/libpng-1.6.51.tar.xz"
  sha256 "a050a892d3b4a7bb010c3a95c7301e49656d72a64f1fc709a90b8aded192bed2"
  license "libpng-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "703cb7b4ef8ce9bf4c7553aa745e10b5a4c9cef31007caece1ec408f474ad7c8"
    sha256 cellar: :any,                 arm64_sequoia: "8bd92ace515a30303692618e9892d2b187f1abe1370159ff6b560475a22fd1db"
    sha256 cellar: :any,                 arm64_sonoma:  "4594d705f39c1364bc2b88643d5347b2e5cdf35b9b2b356d180d5adf2727f7e2"
    sha256 cellar: :any,                 sonoma:        "c32327a289782365e9f9d4c0c812f9732ff580b1c4cef4ecd7d74e5c56f1373b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fd61faa29a5b87cef4e5fb91e5154087bc3f45375d6bb5153ecedf182ee4a65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dc428bdcbc51ffea2cf7da02d4ac2b0d8393b5cfa58f33a232baf1bc4f12c3d"
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
