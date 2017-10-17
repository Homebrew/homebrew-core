class Gmp < Formula
  desc "GNU multiple precision arithmetic library"
  homepage "https://gmplib.org/"
  url "https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz"
  sha256 "87b565e89a9a684fe4ebeeddb8399dce2599f9c9049854ca8c0dfbdea0e21912"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "e245ef776fba2762e245a0182b9c9c74cab2135dc7a29c3bd0811a223e7220ee" => :high_sierra
    sha256 "cd4a916966007092af477a76655cc1f66546d00bf5e581a5dfef334f8436aeb0" => :sierra
    sha256 "01b24de832db7aa24ee14159feb5a16e0e3e18932e6f38d221331bb45feb6a1a" => :el_capitan
    sha256 "3752709f0bab1999fa9d5407bcd3135a873b48fc34d5e6ea123fd68c4cf3644d" => :yosemite
  end

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    args = %W[--prefix=#{prefix} --enable-cxx]
    args << "--build=core2-apple-darwin#{`uname -r`.to_i}" if build.bottle?
    system "./configure", "--disable-static", *args
    system "make"
    system "make", "check"
    system "make", "install"
    system "make", "clean"
    system "./configure", "--disable-shared", "--disable-assembly", *args
    system "make"
    lib.install Dir[".libs/*.a"]
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
  end
end
