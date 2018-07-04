class Liblbfgs < Formula
  desc "C library for Limited-memory Broyden-Fletcher-Goldfarb-Shanno (L-BFGS)"
  homepage "http://www.chokkan.org/software/liblbfgs/"
  url "https://github.com/chokkan/liblbfgs/archive/v1.10.tar.gz"
  sha256 "95c1997e6c215c58738f5f723ca225d64c8070056081a23d636160ff2169bd2f"
  depends_on "gcc" => :build
  depends_on "libtool" => :build
  depends_on "automake"

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <lbfgs.h>

      static lbfgsfloatval_t evaluate(
          void *instance,
          const lbfgsfloatval_t *x,
          lbfgsfloatval_t *g,
          const int n,
          const lbfgsfloatval_t step
          )
      {
          int i;
          lbfgsfloatval_t fx = 0.0;

          for (i = 0;i < n;i += 2) {
              lbfgsfloatval_t t1 = 1.0 - x[i];
              lbfgsfloatval_t t2 = 10.0 * (x[i+1] - x[i] * x[i]);
              g[i+1] = 20.0 * t2;
              g[i] = -2.0 * (x[i] * g[i+1] + t1);
              fx += t1 * t1 + t2 * t2;
          }
          return fx;
      }

      #define N   100

      int main(int argc, char *argv[])
      {
          int i, ret = 0;
          lbfgsfloatval_t fx;
          lbfgsfloatval_t *x = lbfgs_malloc(N);
          lbfgs_parameter_t param;

          if (x == NULL) {
              return 1;
          }

          /* Initialize the variables. */
          for (i = 0;i < N;i += 2) {
              x[i] = -1.2;
              x[i+1] = 1.0;
          }

          /* Initialize the parameters for the L-BFGS optimization. */
          lbfgs_parameter_init(&param);
          /*param.linesearch = LBFGS_LINESEARCH_BACKTRACKING;*/

          /*
              Start the L-BFGS optimization; this will invoke the callback functions
              evaluate() and progress() when necessary.
           */
          ret = lbfgs(N, x, &fx, evaluate, NULL, NULL, &param);

          lbfgs_free(x);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-llbfgs", "-o", "test"
    system "./test"
  end
end
