class Mpfr < Formula
  desc "C library for multiple-precision floating-point computations"
  homepage "http://www.mpfr.org/"
  # Upstream is down a lot, so use mirrors
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mpfr4/mpfr4_3.1.4.orig.tar.xz"
  mirror "https://ftp.gnu.org/gnu/mpfr/mpfr-3.1.4.tar.xz"
  sha256 "761413b16d749c53e2bfd2b1dfaa3b027b0e793e404b90b5fbaeef60af6517f5"

  bottle do
    cellar :any
    sha256 "a5028a476fb01f6f5ee89d635e2cf926c233d6620f036fcfeda2fd963cac369a" => :el_capitan
    sha256 "5047806085670ca9f39de8e9afdec2ab82eddb7d1d3154208262f844b43b4dcd" => :yosemite
    sha256 "f1c281e854533cf7fab36396591516d48a61626096f152ea828eaae9f7c09238" => :mavericks
    sha256 "5a98a6a8dd768c845602cabb31db527a0efecdbae3eaa1148db8010ae5420a97" => :mountain_lion
  end

  # http://www.mpfr.org/mpfr-current/allpatches
  patch do
    url "https://raw.githubusercontent.com/Homebrew/patches/30141937f9d16/mpfr/3.1.4-patches.diff"
    sha256 "9a03c3f304feaff747d1832f4a0f3653bbd24764df403305add0b76ca6cd6541"
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
