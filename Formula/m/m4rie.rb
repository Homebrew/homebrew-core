class M4rie < Formula
  desc "Library for fast arithmetic with dense matrices over GF(2^e), 2<=e<=16"
  homepage "https://bitbucket.org/malb/m4rie"
  url "https://github.com/malb/m4rie/releases/download/20250128/m4rie-20250128.tar.gz"
  sha256 "96f1adafd50e6a0b51dc3aa1cb56cb6c1361ae7c10d97dc35c3fa70822a55bd7"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "21f9f9dc9b232eb6ac5886157ceae1b9c4bd8c3035563cf586fa89d8994854a4"
    sha256 cellar: :any, arm64_sequoia: "eb00887b658776dcd0188d91e7e9ebe566d0639b99cf480f7e9ced7c4286403b"
    sha256 cellar: :any, arm64_sonoma:  "86024f078a5679aa1762969fa7975f9aec027d938f13ea68080bd8be813e6da5"
    sha256 cellar: :any, sonoma:        "327533a520090faca319aae365b332bd2164cd634fa5ecb75f8997833f8654a0"
    sha256 cellar: :any, arm64_linux:   "ddf8c798e1ced9e5549f319935dad78060d89ff00cc3c9e234e38a99ea4b9075"
    sha256 cellar: :any, x86_64_linux:  "01693940fe629c5c593ff1fc8faad7b48bb9425890c399e8eb8230f257d5abaa"
  end

  depends_on "libpng"
  depends_on "m4ri"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <m4rie/m4rie.h>

      const size_t d = 3;
      const size_t m = 1024;
      const size_t n = 1024;
      const size_t l = 1024;

      int mzed_test(const size_t d, const size_t m, const size_t n, const size_t l) {
        gf2e *ff = gf2e_init(irreducible_polynomials[d][1]);

        mzed_t *A = mzed_init(ff, m, n);
        mzed_randomize(A);
        mzed_t *B = mzed_init(ff, m, n);
        mzed_randomize(B);
        mzed_t *C = mzed_init(ff, n, l);
        mzed_randomize(C);

        // AC + BC = (A+B)C
        mzed_t *R0 = mzed_mul(NULL, A, C);
        mzed_addmul(R0, B, C);

        mzed_t *T0 = mzed_add(NULL, A, B);
        mzed_t *R1 = mzed_mul(NULL, T0, C);

        int r = mzed_cmp(R0, R1);

        mzed_free(R1);
        mzed_free(T0);
        mzed_free(R0);
        mzed_free(C);
        mzed_free(B);
        mzed_free(A);

        return r;
      }

      int mzd_slice_test(const size_t d, const size_t m, const size_t n,
                         const size_t l) {
        gf2e *ff = gf2e_init(irreducible_polynomials[d][1]);

        mzd_slice_t *A = mzd_slice_init(ff, m, n);
        mzd_slice_randomize(A);
        mzd_slice_t *B = mzd_slice_init(ff, m, n);
        mzd_slice_randomize(B);
        mzd_slice_t *C = mzd_slice_init(ff, n, l);
        mzd_slice_randomize(C);

        // AC + BC = (A+B)C
        mzd_slice_t *R0 = mzd_slice_mul(NULL, A, C);
        mzd_slice_addmul(R0, B, C);

        mzd_slice_t *T0 = mzd_slice_add(NULL, A, B);
        mzd_slice_t *R1 = mzd_slice_mul(NULL, T0, C);

        int r = mzd_slice_cmp(R0, R1);

        mzd_slice_free(R1);
        mzd_slice_free(T0);
        mzd_slice_free(R0);
        mzd_slice_free(C);
        mzd_slice_free(B);
        mzd_slice_free(A);

        return r;
      }

      int main(int argc, char *argv[]) {
        int r0 = mzed_test(d, m, n, l);
        int r1 = mzd_slice_test(d, m, n, l);

        if (r0 | r1) {
          fprintf(stderr, "M4RIE test failed.");
          return -1;
        } else {
          fprintf(stderr, "M4RIE test passed.");
          return 0;
        }
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lm4rie", "-L#{Formula["m4ri"].lib}", "-lm4ri", "-o", "test"
    system "./test"
  end
end
