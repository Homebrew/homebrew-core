class Blis < Formula
  desc "BLAS-like Library Instantiation Software Framework"
  homepage "https://github.com/flame/blis"
  url "https://github.com/flame/blis/archive/0.7.0.tar.gz"
  sha256 "7e345d666799e15bba570bd125f97042f17bf752a61dcf314486a6cd096d5f68"
  head "https://github.com/flame/blis.git"

  bottle do
    cellar :any
    sha256 "833292d80566465ddee4fd015eb8daaef54ecd13abe967e7d4a4651deaeeb553" => :catalina
    sha256 "4219b30cc48ec6ba7387cefa64521b8fcc6d561e0805bf06da367d4fdfdd3dcf" => :mojave
    sha256 "6e56b9cb5810039080cb2e0af79bf50709815b6acc959d4580a9a42c6c092661" => :high_sierra
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
