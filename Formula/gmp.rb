class Gmp < Formula
  desc "GNU multiple precision arithmetic library"
  homepage "https://gmplib.org/"
  url "https://gmplib.org/download/gmp/gmp-6.2.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gmp/gmp-6.2.0.tar.xz"
  sha256 "258e6cd51b3fbdfc185c716d55f82c08aff57df0c6fbd143cf6ed561267a1526"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2409417943fceda33eac12a8229fbf7b990eee18ee341b543be575550a077bb0" => :catalina
    sha256 "84f74594086bccc53bdb141f4d06d7847680374e255ebe016654da1e47db2dfc" => :mojave
    sha256 "a536c51149806b73b2e1178be94300832b6b151455006bc7f2a32b9dc493c7a3" => :high_sierra
    sha256 "ada22a8bbfe8532d71f2b565e00b1643beaf72bff6b36064cbad0cd7436e4948" => :sierra
  end

  def install
    # Enable --with-pic to avoid linking issues with the static library
    args = %W[--prefix=#{prefix} --enable-cxx --with-pic]
    args << "--build=#{Hardware.oldest_cpu}-apple-darwin#{`uname -r`.to_i}"
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gmp.h>
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

    system ENV.cc, "test.c", "-L#{lib}", "-lgmp", "-o", "test"
    system "./test"

    # Test the static library to catch potential linking issues
    system ENV.cc, "test.c", "#{lib}/libgmp.a", "-o", "test"
    system "./test"
  end
end
