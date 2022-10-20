class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.38/libpng-1.6.38.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.38/libpng-1.6.38.tar.xz"
  sha256 "b3683e8b8111ebf6f1ac004ebb6b0c975cd310ec469d98364388e9cedbfa68be"
  license "libpng-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f2be24349bfc0c8a394cf49a2894f696124678dedbef660a5619d7ba43b01bef"
    sha256 cellar: :any,                 arm64_big_sur:  "8bb66c5e3b69b2d8d230d6981b5cad0705123a6bd1f595588d5e351d188ba4b2"
    sha256 cellar: :any,                 monterey:       "e75fbecd6315ba103d809ba3865aa68d8d31545596b0c17ef571383f01e71dee"
    sha256 cellar: :any,                 big_sur:        "f7c24d520a5fd31a2239c8dce881bb901ddd2a7ec6e73036b89a9ce8d46d6478"
    sha256 cellar: :any,                 catalina:       "65855205eec15c0c1c6cf47f9a3293c338df5feef348525887da82fb0ad4a448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64f8a82224209e8c412cf03593ef322112e3674ac87ad54ee46114c9f40d0a6e"
  end

  head do
    url "https://github.com/glennrp/libpng.git"

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
