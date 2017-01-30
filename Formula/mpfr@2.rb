class MpfrAT2 < Formula
  desc "Multiple-precision floating-point computations C lib"
  homepage "http://www.mpfr.org/"
  # Track gcc infrastructure releases.
  url "http://www.mpfr.org/mpfr-2.4.2/mpfr-2.4.2.tar.bz2"
  mirror "ftp://gcc.gnu.org/pub/gcc/infrastructure/mpfr-2.4.2.tar.bz2"
  sha256 "c7e75a08a8d49d2082e4caee1591a05d11b9d5627514e678f02d66a124bcf2ba"

  bottle do
    cellar :any
    sha256 "40b794dc63736c1d99d12488acce77e88ec699880d6c43e8fa12d67eda450a21" => :sierra
    sha256 "d555463688c8a8728989a9ef5f90693962cf6cf5297952e04e9ac25276e94edb" => :el_capitan
    sha256 "fad9992e12b9dab83c8630330e1e5b4a612380b6f0258ac77b1ac512b6286e1e" => :yosemite
  end

  keg_only :versioned_formula

  depends_on "gmp@4"

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      clang build 421 segfaults while building in superenv;
      see https://github.com/mxcl/homebrew/issues/15061
      EOS
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-gmp=#{Formula["gmp@4"].opt_prefix}
    ]

    # Build 32-bit where appropriate, and help configure find 64-bit CPUs
    # Note: This logic should match what the GMP formula does.
    if MacOS.prefer_64_bit?
      ENV.m64
      args << "--build=x86_64-apple-darwin"
    else
      ENV.m32
      args << "--build=none-apple-darwin"
    end

    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gmp.h>
      #include <mpfr.h>

      int main()
      {
        mpfr_t x;
        mpfr_init(x);
        mpfr_clear(x);
        return 0;
      }
    EOS
    gmp = Formula["gmp@4"]
    system ENV.cc, "test.c", "-o", "test",
                   "-lgmp", "-I#{gmp.include}", "-L#{gmp.lib}",
                   "-lmpfr", "-I#{include}", "-L#{lib}"
    system "./test"
  end
end
