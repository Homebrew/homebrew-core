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
    sha256 cellar: :any,                 arm64_sequoia:  "51f0ca19e897731b928742401c9c8d1d7d93c3c275aa8a66a77b9ac01d0c223c"
    sha256 cellar: :any,                 arm64_sonoma:   "71c4d6cc59a5bee30e0779b1d095c2e2db1cb63b51eac88d5d4191660e613d0c"
    sha256 cellar: :any,                 arm64_ventura:  "28014245ba2ce1edebadedea884f9749c6c588352d938472821bc5c9e0f866cc"
    sha256 cellar: :any,                 arm64_monterey: "209306f204f9cc2db3a1a500a9426f18e410f7783914d41e09e39782f94c55da"
    sha256 cellar: :any,                 sequoia:        "862f19b07059671cf89b4e14b0d9d3242bcccaf5f118e7480bab2f03a323390a"
    sha256 cellar: :any,                 sonoma:         "af35898aedfbb852d0ff927c1c60bf3676c2c29c61408f971490e1289b40cc5b"
    sha256 cellar: :any,                 ventura:        "b8363c20660b5304f2ab4d73614a4c5bec7461d7cf245f02ef05e965477e67e6"
    sha256 cellar: :any,                 monterey:       "6e073b5307a7376673527aef03644a5bdd27c0abe9a0739a3be3275a3567efa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18857bac44d9f49faeb1d147146ba7fb420d5bf85076f69c68a86a563b203c13"
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

    system "./configure", *std_configure_args,
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
