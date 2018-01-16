class Mpir < Formula
  desc "Multiple Precision Integers and Rationals (fork of GMP)"
  homepage "http://mpir.org/"
  url "http://mpir.org/mpir-3.0.0.tar.bz2"
  sha256 "52f63459cf3f9478859de29e00357f004050ead70b45913f2c2269d9708675bb"

  depends_on "yasm" => :build

  def install
    args = %W[--disable-silent-rules --prefix=#{prefix} --enable-cxx]

    # Prevent bottles from being optimized for specific CPU model
    args << "--build=core2-apple-darwin#{`uname -r`.to_i}" if build.bottle?

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
