class Mpfr < Formula
  desc "C library for multiple-precision floating-point computations"
  homepage "https://www.mpfr.org/"
  license "LGPL-3.0-or-later"

  stable do
    url "https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.0.tar.xz"
    mirror "https://ftpmirror.gnu.org/mpfr/mpfr-4.2.0.tar.xz"
    sha256 "06a378df13501248c1b2db5aa977a2c8126ae849a9d9b7be2546fb4a9c26d993"
    version "4.2.0-p9"

    # Upstream patches, list at https://www.mpfr.org/mpfr-current/#fixed
    %w[
      01 2e465c31689e780a93b24bf2959917443fb882da85b7f1ef23ae53d3de614aa4
      02 e1ef3d4dab999f4e0ad5ee046c3a2823d3a9395fb8092c3dcb85d3fe29994b52
      03 a906f9ed8e4a7230980322a0154702664164690614e5ff55ae7049c3fae55584
      04 ece14ee57596dc2e4f67d2e857c5c6b23d76b20183a50a8b6759b640df001b78
      05 c4144564097a1be89c9cc2e7ee255c9fe59eb1b94a17c9d4a08169223e705ac1
      06 70456748a8072265ba103d93ba94e9f93ae64565e6a5742194c56030086540fa
      07 472386aa5f8c51fbdf60154c19268ce2212be03e1c2f9004c1673b6c270508f6
      08 6ecd3bd2edf178f4ede4be612964d1b2d0a0bb10ad6f8c51d1a8011fff87d5ea
      09 3e9aed5bcea95d34d0bd179a61cd7acb712c89c9a745535f18f0ef619833ba3b
    ].each_slice(2) do |p, checksum|
      patch do
        url "https://www.mpfr.org/mpfr-4.2.0/patch#{p}"
        sha256 checksum
      end
    end
  end

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
    sha256 cellar: :any,                 arm64_ventura:  "176114984411aeb1187a50fd9ffc39d7dfe0bf5dc29ab13b0ecc95307d619ff9"
    sha256 cellar: :any,                 arm64_monterey: "77a979ab547618549fc85a12212abd57b085b1712c53299847966d76a4e261f9"
    sha256 cellar: :any,                 arm64_big_sur:  "f5776604dbb68288c8dfe371e46398a671b6c34329ad473ada5d4e1fa7562086"
    sha256 cellar: :any,                 ventura:        "781d9c4887b8b18ccb96653ce59bb9aa5ee49dd1fb6c7d804750f58ce8726a2f"
    sha256 cellar: :any,                 monterey:       "a8eb9e75c01527d80843daba945a7581942362e689e3f3b7c6c891daa2655e9e"
    sha256 cellar: :any,                 big_sur:        "22360e6d89681f3d3d326a5654ab0cfb22d5ac42241c40e9f8f91eb06bb1b77c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0cafd93a5957220615ae6478033031b750ba5eb6a830cf86d4cbde5bffec8d5"
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
