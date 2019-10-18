class Mpir < Formula
  desc "Multiple Precision Integers and Rationals (fork of GMP)"
  homepage "http://mpir.org/"
  url "http://mpir.org/mpir-3.0.0.tar.bz2"
  sha256 "52f63459cf3f9478859de29e00357f004050ead70b45913f2c2269d9708675bb"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d45de304310770a0788c528faff83b5c16ad8903f54e7788fcb5b0d16182d049" => :catalina
    sha256 "5fd2ec4df58a2c8a1dd74729c90dd6928893f9c87c8ee06af8519dfb7ea9d71f" => :mojave
    sha256 "e9786b8cd2ee485e34b6e63c95bb7f71289c038dc9be0fdf583279853056302a" => :high_sierra
    sha256 "006955801271b94f2e412ac056450000785965ed631d134554d7190deaf675d1" => :sierra
  end

  depends_on "yasm" => :build

  def install
    args = %W[--disable-silent-rules --prefix=#{prefix} --enable-cxx]
    args << "--build=#{Hardware.oldest_cpu}-apple-darwin#{`uname -r`.to_i}"
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mpir.h>
      #include <stdlib.h>

      int main() {
        mpz_t i, j, k;
        mpz_init_set_str (i, "1a", 16);
        mpz_init (j);
        mpz_init (k);
        mpz_sqrtrem (j, k, i);
        if (mpz_get_si (j) != 5 || mpz_get_si (k) != 1) abort();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmpir", "-o", "test"
    system "./test"
  end
end
