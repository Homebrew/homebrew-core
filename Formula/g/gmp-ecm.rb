class GmpEcm < Formula
  desc "Elliptic Curve Method for integer factorization"
  homepage "https://gitlab.inria.fr/zimmerma/ecm"
  url "https://gitlab.inria.fr/zimmerma/ecm/-/archive/git-7.0.7/ecm-git-7.0.7.tar.gz"
  sha256 "cfc1c0745694e7b24a8a373d8e854f8ab42cff177dbd98beba3b093e3858ca8a"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://gitlab.inria.fr/zimmerma/ecm.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "910a4e7d0f0571f1c81ff8911ce572848b8a0f9b0418078b14212f2631b54e03"
    sha256 cellar: :any, arm64_sequoia: "2751998af4e5ac3635c65af6e7ad8cc9d6903e12f10fd4c8d0fea310a3d37f08"
    sha256 cellar: :any, arm64_sonoma:  "208c99b0b737ee4c2a49a253c1e66d6ee60cb0cb7f2b250cd674d92afd39cc28"
    sha256 cellar: :any, sonoma:        "548c687bccc54579afdfde56b4f3f22efd32c38aaed35774ecab1549933aeae3"
    sha256 cellar: :any, arm64_linux:   "8f397ecad250210a53655b2f102c034d1ff25aba705be4160abef37f82720c4f"
    sha256 cellar: :any, x86_64_linux:  "434fca76ae486e7df0ca2ce4fbb365b497963b81ed8e30c38879dc40b7bb9a6c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gmp"
  depends_on "primesieve"

  uses_from_macos "m4" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--enable-openmp", "--enable-shared", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    # Test the ecm binary: factor 121 = 11 * 11
    assert_match "Factor found", pipe_output("#{bin}/ecm 100", "121\n")

    # Test linking against libecm using the P-1 method, which is
    # deterministic: P-1 with B1=5 finds 31 from 3937 = 31 * 127
    # because 31-1 = 30 = 2*3*5 is 5-smooth while
    # 127-1 = 126 = 2*3^2*7 is not.
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <gmp.h>
      #include <ecm.h>

      int main(void) {
        mpz_t n, f;
        ecm_params q;

        mpz_init_set_ui(n, 3937);
        mpz_init(f);
        ecm_init(q);

        q->method = ECM_PM1;

        int ret = ecm_factor(f, n, 5.0, q);
        if (ret <= 0 || mpz_cmp_ui(f, 31) != 0)
          return 1;

        ecm_clear(q);
        mpz_clear(f);
        mpz_clear(n);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test",
           "-I#{include}", "-L#{lib}", "-L#{Formula["gmp"].lib}",
           "-L#{Formula["primesieve"].lib}",
           "-lecm", "-lgmp", "-lprimesieve"
    system "./test"
  end
end
