class M4ri < Formula
  desc "Library for fast arithmetic with dense matrices over F2."
  homepage "https://bitbucket.org/malb/m4ri"
  url "https://bitbucket.org/malb/m4ri/downloads/m4ri-20140914.tar.gz"
  sha256 "4bc3f53a5116e1ff0720c08f34ce415c88e2fb503437abfd15e196792ec6d5aa"

  depends_on "libpng" => :recommended

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
    #include <m4ri/m4ri.h>

    mzd_t *mzd_init_test_matrix_random(rci_t M, rci_t N, rci_t m, rci_t n, word pattern, mzd_t **A) {
      *A = mzd_init(M, N);

      for(rci_t i=0; i<M; i++) {
        for(rci_t j=0; j<(*A)->width; j++) {
          (*A)->rows[i][j] = pattern;
        }
      }

      mzd_t* a = mzd_init_window(*A, 0, 0, m, n);
      mzd_randomize(a);

      return a;
    }

    void mzd_free_test_matrix_random(mzd_t *A, mzd_t *a) {
      mzd_free(a);
      mzd_free(A);
    }

    int mzd_check_pattern(mzd_t *A, rci_t m, rci_t n, word pattern) {

      for(rci_t i=0; i<A->nrows; i++) {
        if (i >= m) {
          for(rci_t j=0; j<A->width; j++)
            if(A->rows[i][j] ^ pattern) {
              return 1;
            }
        } else {
          if ((A->rows[i][n/m4ri_radix] ^ pattern) & ~A->high_bitmask )
            return 1;

          for(rci_t j=n/m4ri_radix+1; j<A->width; j++)
            if(A->rows[i][j] ^ pattern) {
              return 1;
            }
        }
      }
      return 0;
    }

    int test_kernel_left_pluq(rci_t m, rci_t n) {
      mzd_t* A = mzd_init(m, n);
      mzd_randomize(A);

      mzd_t *Acopy = mzd_copy(NULL, A);

      rci_t r = mzd_echelonize_m4ri(A, 0, 0);
      mzd_free(Acopy);
      Acopy = mzd_copy(NULL, A);

      mzd_t *X = mzd_kernel_left_pluq(A, 0);
      if (X == NULL) {
        mzd_free(A);
        mzd_free(Acopy);
        return 0;
      }

      mzd_t *Z = mzd_mul(NULL, Acopy, X, 0);

      int status = 1 - mzd_is_zero(Z);

      mzd_free(A);
      mzd_free(Acopy);
      mzd_free(X);
      mzd_free(Z);
      return status;
    }

    int main() {
      int status = 0;

      srandom(17);

      status += test_kernel_left_pluq(  2,   4);
      status += test_kernel_left_pluq(  4,   1);
      status += test_kernel_left_pluq( 10,  20);
      status += test_kernel_left_pluq( 20,   1);
      status += test_kernel_left_pluq( 20,  20);
      status += test_kernel_left_pluq( 30,   1);
      status += test_kernel_left_pluq( 30,  30);
      status += test_kernel_left_pluq( 80,   1);
      status += test_kernel_left_pluq( 80,  20);
      status += test_kernel_left_pluq( 80,  80);

      status += test_kernel_left_pluq( 4,  2);
      status += test_kernel_left_pluq( 1,  4);
      status += test_kernel_left_pluq(20, 10);
      status += test_kernel_left_pluq( 1, 20);
      status += test_kernel_left_pluq(20, 20);
      status += test_kernel_left_pluq( 1, 30);
      status += test_kernel_left_pluq(30, 30);
      status += test_kernel_left_pluq( 1, 80);
      status += test_kernel_left_pluq(20, 80);
      status += test_kernel_left_pluq(80, 80);

      status += test_kernel_left_pluq(10, 20);
      status += test_kernel_left_pluq(10, 80);
      status += test_kernel_left_pluq(10, 20);
      status += test_kernel_left_pluq(10, 80);
      status += test_kernel_left_pluq(70, 20);
      status += test_kernel_left_pluq(70, 80);
      status += test_kernel_left_pluq(70, 20);
      status += test_kernel_left_pluq(70, 80);
      status += test_kernel_left_pluq(770, 1600);
      status += test_kernel_left_pluq(1764, 1345);

      if (status) {
        return 1;
      }

      return 0;
    }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lm4ri", "-o", "test"
    system "./test"
  end
end
