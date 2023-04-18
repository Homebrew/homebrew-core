class Mpfr < Formula
  desc "C library for multiple-precision floating-point computations"
  homepage "https://www.mpfr.org/"
  url "https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/mpfr/mpfr-4.2.0.tar.xz"
  sha256 "06a378df13501248c1b2db5aa977a2c8126ae849a9d9b7be2546fb4a9c26d993"
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

      "#{version}-p#{patch}"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e8d923fe4d12887beeb011b2486890d9fd7bf13a821bab1adb4932edd7b5a802"
    sha256 cellar: :any,                 arm64_monterey: "d3f7d7d6a2007613f6ae700bad01c0b998d3725a21d8168652867c18c5223fa9"
    sha256 cellar: :any,                 arm64_big_sur:  "018f507d932c6fa5ab125616a176454e08e4a1e5512ea0958aaf66ae592408d1"
    sha256 cellar: :any,                 ventura:        "710c8543bd3e5f0f157efc66a47de9054eb42c782d3d6fd70a3c9163befb021a"
    sha256 cellar: :any,                 monterey:       "f5901c68e23d7ffbe0b58f1f6e89a57d63d7a9ab167df19c2ea3fc0f89fa217e"
    sha256 cellar: :any,                 big_sur:        "0d0608dce4879e2060efaf13e65b016ad481617dd960bc9674af8d8f0011192c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e62ca94c057c73dfb08c6b7be42b3aaf0e338c9a422dbdd74695e1106c302a5"
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
