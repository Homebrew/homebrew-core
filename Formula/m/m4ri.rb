class M4ri < Formula
  desc "Library for fast arithmetic with dense matrices over GF(2)"
  homepage "https://github.com/malb/m4ri"
  url "https://github.com/malb/m4ri/releases/download/20260122/m4ri-20260122.tar.gz"
  sha256 "7e033ca1fd36be8861e2f67d9d124c398fc0d830209bb0226462485876346404"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "86ce9e345f247c809a92ddd82507f17b08e045257d79bfc7ec46ad4586a84bb4"
    sha256 cellar: :any,                 arm64_sequoia: "c81300628bad5a1186de3e62ebb707bb007fa48d5d92935e21495eee74717cef"
    sha256 cellar: :any,                 arm64_sonoma:  "efad1f22b119875e7c8f022d5fd6a8588d59d6079952f21b28635f43c20f7635"
    sha256 cellar: :any,                 sonoma:        "6413a9a63015145d5050c025356b575caa38bf6d17b48831cf77c6d5e71f5f32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ff04f54801aecbebfe0fe0b448cc4a1feb889e5c44cd2012c1d791eee8f3d93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b68236d8084e25816857bdec78252195bb8c8fc8b8aa21c699e77c97ce4188dc"
  end

  depends_on "libpng"

  def install
    system "./configure", "--disable-openmp", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <m4ri/m4ri.h>

      const size_t m = 1024;
      const size_t n = 1024;
      const size_t l = 1024;

      int main(int argc, char *argv[]) {
        mzd_t *A = mzd_init(m, n);
        mzd_randomize(A);
        mzd_t *B = mzd_init(m, n);
        mzd_randomize(B);
        mzd_t *C = mzd_init(n, l);
        mzd_randomize(C);

        // AC + BC = (A+B)C
        mzd_t *R0 = mzd_mul(NULL, A, C, 0);
        mzd_addmul(R0, B, C, 0);

        mzd_t *T0 = mzd_add(NULL, A, B);
        mzd_t *R1 = mzd_mul(NULL, T0, C, 0);

        int r = mzd_equal(R0, R1);

        FILE *fh = tmpfile();
        mzd_to_png_fh(A, fh, 1, NULL, 0);
        fflush(fh);
        fseek(fh, 0, SEEK_SET);
        mzd_t *AA = mzd_from_png_fh(fh, 0);
        fclose(fh);
        r &= mzd_equal(A, AA);

        mzd_free(AA);
        mzd_free(T0);
        mzd_free(R1);
        mzd_free(R0);

        mzd_free(C);
        mzd_free(B);
        mzd_free(A);

        if (r == TRUE) {
          fprintf(stderr, "M4RI test passed.");
          return 0;
        } else {
          fprintf(stderr, "M4RI test failed.");
          return -1;
        }
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lm4ri", "-o", "test"
    system "./test"
  end
end
