class Mpfr < Formula
  desc "C library for multiple-precision floating-point computations"
  homepage "https://www.mpfr.org/"
  url "https://ftpmirror.gnu.org/gnu/mpfr/mpfr-4.2.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.2.tar.xz"
  sha256 "b67ba0383ef7e8a8563734e2e889ef5ec3c3b898a01d00fa0a6869ad81c6ce01"
  license "LGPL-3.0-or-later"
  head "https://gitlab.inria.fr/mpfr/mpfr.git", branch: "master"

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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "495b04c82ef8638368a5cc62141e7ac195377d292503f5b30e5915b1ff478dda"
    sha256 cellar: :any,                 arm64_sequoia: "ed822b7e77645d7c17abb3ee9cc2b2a82a4d0f003acc7615b5df6226031479b2"
    sha256 cellar: :any,                 arm64_sonoma:  "15168719e4dbbc4f497e6f7ec91dfec55659113020e2af705a704af566dbe888"
    sha256 cellar: :any,                 arm64_ventura: "12528a52c96fb1318bf07778ee236d69f4f1c67e616f0c97375431056c27e34e"
    sha256 cellar: :any,                 tahoe:         "0d1e2577e9911e6c8ece360c9a18292c373f23131fb72e6b73987b5216ca4e4b"
    sha256 cellar: :any,                 sequoia:       "ba4a1b8388386e6618de7c7e27199ae8de473373330f5773e2095567a71d76fd"
    sha256 cellar: :any,                 sonoma:        "d0d63cabde366839e9140f92451c7e53f7a89d1986d1903bc9851f6122916213"
    sha256 cellar: :any,                 ventura:       "69c8ea465b74361779391dd02f3fcb474f72d4f76d43dc0c2597fd4c1358936e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc5527d722406e18631498339752226ebebecc915bf5da08bfa48cffebeb1ba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91dfeb407daeeabb3c3caceb89af41dc02b1aa473b88e76c7533efbc2ad6066d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gmp"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-L#{lib}", "-L#{Formula["gmp"].opt_lib}",
                   "-lgmp", "-lmpfr", "-o", "test"
    system "./test"
  end
end
