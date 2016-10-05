class Mpfr < Formula
  desc "C library for multiple-precision floating-point computations"
  homepage "http://www.mpfr.org/"
  # Upstream is down a lot, so use mirrors
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mpfr4/mpfr4_3.1.5.orig.tar.xz"
  mirror "https://ftp.gnu.org/gnu/mpfr/mpfr-3.1.5.tar.xz"
  sha256 "015fde82b3979fbe5f83501986d328331ba8ddf008c1ff3da3c238f49ca062bc"

  bottle do
    cellar :any
    sha256 "563898b76509b25a1c7ed09c3f541310569d7c124f1edc84638ecec75e507698" => :sierra
    sha256 "f9ae415a51042ad963dfd8d6171556b0119a27edbe894614c0e3a2e4398515c4" => :el_capitan
    sha256 "ca737c71556161c37563b78305aa93c6663cde07f06d94e4d7de091983327c48" => :yosemite
  end

  option "32-bit"

  depends_on "gmp"

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      clang build 421 segfaults while building in superenv;
      see https://github.com/Homebrew/homebrew/issues/15061
    EOS
  end

  def install
    ENV.m32 if build.build_32_bit?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"
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
    system ENV.cc, "test.c", "-lgmp", "-lmpfr", "-o", "test"
    system "./test"
  end
end
