class Blis < Formula
  desc "BLAS-like Library Instantiation Software Framework"
  homepage "https://github.com/flame/blis"
  url "https://github.com/flame/blis/archive/0.6.0.tar.gz"
  sha256 "ad5765cc3f492d0c663f494850dafc4d72f901c332eb442f404814ff2995e5a9"
  head "https://github.com/flame/blis.git"

  bottle do
    cellar :any
    sha256 "7d992963cd513a7a08e934f078698c145d3778a97abefff7744e497926d8ce98" => :catalina
    sha256 "9bd7f60d824d7b291dac639b5af609066593a8afa3a64d62ece5bdd4f12bba92" => :mojave
    sha256 "80050a00c1bbf25a6f7fc31ec7cacf0d911adb4c68d68e57afe60f607082261b" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-cblas", "auto"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <math.h>
      #include "blis/blis.h"

      int main(void) {
        int i;
        double A[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double B[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double C[9] = {.5, .5, .5, .5, .5, .5, .5, .5, .5};
        cblas_dgemm(CblasColMajor, CblasNoTrans, CblasTrans,
                    3, 3, 2, 1, A, 3, B, 3, 2, C, 3);
        for (i = 0; i < 9; i++)
          printf("%lf ", C[i]);
        printf("\\n");
        if (fabs(C[0]-11) > 1.e-5) abort();
        if (fabs(C[4]-21) > 1.e-5) abort();
        return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{include}", "-L#{lib}", "-lblis", "-lm"
    system "./test"
  end
end
