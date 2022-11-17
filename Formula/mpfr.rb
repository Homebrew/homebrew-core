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
    sha256 cellar: :any,                 arm64_ventura:  "dc15dfe27723d98db1993901a221b2647f9fa239afec236100c5b39ec8dbe35c"
    sha256 cellar: :any,                 arm64_monterey: "57c5c5b16ed462b28c2691c8284bdd6849cf668b190a59cc6e1cdb1971f57ce2"
    sha256 cellar: :any,                 arm64_big_sur:  "7bd20206002bf9839c3477d1c1013b6000953e2f2b13f9f252184037c8c05d88"
    sha256 cellar: :any,                 ventura:        "761ce021145d2a2a4fb3970872b684bd2703026c40f0cacdc764846108d211b3"
    sha256 cellar: :any,                 monterey:       "1007b284b2bc9825f8aa1f2bf3162ff8d2ca8f5d0c3c9802c8a9be452677648e"
    sha256 cellar: :any,                 big_sur:        "e220a942ee9fcbe777b8bacee4669f84deddf08bd1dc2f65e44da7ab2349719a"
    sha256 cellar: :any,                 catalina:       "ec511d6651ef65d53be5f7b2210b0dd78bee017b7a8d48c8db2175ad16a4e086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "345a3d99db0f4149f84f0aa16c0ee9c4275f695e4fa0f6d2ae1e8054a0d9c279"
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
