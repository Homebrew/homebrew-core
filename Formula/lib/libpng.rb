class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.50/libpng-1.6.50.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.50/libpng-1.6.50.tar.xz"
  sha256 "4df396518620a7aa3651443e87d1b2862e4e88cad135a8b93423e01706232307"
  license "libpng-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0e84944536d6bf2c7cfd393a4576acf5c0ced03992d156685a7f83c7d2a60215"
    sha256 cellar: :any,                 arm64_sonoma:  "caa7ba5098ae80b04910efc2770473a566245c2f1cf8c3d6b1d2b1bd5624eadb"
    sha256 cellar: :any,                 arm64_ventura: "cdfd6a7ecad2bab898b901fbdc1afd85403544bd6ceecb0dbeef363ba21c09ec"
    sha256 cellar: :any,                 sonoma:        "e75d186e750e25eaec263712695e32f90f1db116a7b1b6800e4f1d8b8fcd26f5"
    sha256 cellar: :any,                 ventura:       "4ec5a2b7501d6a1a262a6cb085ce39bf59d1486df6dad67d0a8c232ca987e14b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdb4a903c664637380ada15baacdfb2c056caaa7c8a52993cd706d4d230f318b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2627ebf8ea1ead44fff53f5dbf7e6ce737626286ac6dac60d815c6cc8e83e3a0"
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
