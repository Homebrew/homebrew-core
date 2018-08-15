class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/libpng/libpng-1.6.35.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.35/libpng-1.6.35.tar.xz"
  sha256 "23912ec8c9584917ed9b09c5023465d71709dce089be503c7867fec68a93bcd7"

  bottle do
    cellar :any
    sha256 "8a76a432c62a531b61f7229ce23977ff4accb2b8ee7c65cef886184c36500558" => :mojave
    sha256 "6d87a8bac8290bef728e8faf1d39a963e0602d9ef89e465b05e463c62a64ad88" => :high_sierra
    sha256 "a0adbf626e9f20ac0895a9fe27a2ed68e1b63421f15d8b1018d7071037d5c48a" => :sierra
    sha256 "dd8d9907825e0398f96fd8482455654f805985e5eb6d0a319b421f64f3c81db1" => :el_capitan
  end

  head do
    url "https://github.com/glennrp/libpng.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

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
