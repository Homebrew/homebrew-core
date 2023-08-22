class Mpfr < Formula
  desc "C library for multiple-precision floating-point computations"
  homepage "https://www.mpfr.org/"
  url "https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/mpfr/mpfr-4.2.1.tar.xz"
  sha256 "277807353a6726978996945af13e52829e3abd7a9a5b7fb2793894e18f1fcbb2"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.mpfr.org/mpfr-current/"
    regex(/href=.*?mpfr[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :page_match do |page, regex|
      version = page.scan(regex).map { |match| Version.new(match[0]) }.max&.to_s
      next if version.blank?

      patch = page.scan(%r{href=["']?/?patch(\d+)["' >]}i)
                  .map { |match| Version.new(match[0]) }
                  .max
                  &.to_s
      next version if patch.blank?

      "#{version}-p#{patch.to_i}"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "43db595106704b53119e8d45c2a28a157b78c488bd31144490338cacf5180232"
    sha256 cellar: :any,                 arm64_monterey: "a914ea0e50fac5f8120a2dfba9bc49d23ad81c9270f7332de3cbadb81c86ae70"
    sha256 cellar: :any,                 arm64_big_sur:  "7b3a7b20653a16f26c7bf810b7fb72985dc098695657f1634fe87784dc0bedd5"
    sha256 cellar: :any,                 ventura:        "18a11c948c4c7a783165b75d31c90c5cbc58b8ebe61ad268ffe3bf92ec2ac21d"
    sha256 cellar: :any,                 monterey:       "d6879fb531aac96a5898ee13d929d6a01d394a63906de0b2a24c1a5f67d067f5"
    sha256 cellar: :any,                 big_sur:        "1d0680b952c9789665a1deb684382d781db88fa081e53029b4e6013fbbc9f01f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57c89c97863cb0d08251271de84ae157b364af3b304a0c0e8a13bdd57d4f026a"
  end

  head do
    url "https://gitlab.inria.fr/mpfr/mpfr.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mpfr.h>
      #include <math.h>
      #include <stdlib.h>
      #include <string.h>

      int main() {
        mpfr_t x, y;
        mpfr_inits2 (256, x, y, NULL);
        mpfr_set_ui (x, 2, MPFR_RNDN);
        mpfr_rootn_ui (y, x, 2, MPFR_RNDN);
        mpfr_pow_si (x, y, 4, MPFR_RNDN);
        mpfr_add_si (y, x, -4, MPFR_RNDN);
        mpfr_abs (y, y, MPFR_RNDN);
        if (fabs(mpfr_get_d (y, MPFR_RNDN)) > 1.e-30) abort();
        if (strcmp("#{version}", mpfr_get_version())) abort();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-L#{Formula["gmp"].opt_lib}",
                   "-lgmp", "-lmpfr", "-o", "test"
    system "./test"
  end
end
