class Blis < Formula
  desc "BLAS-like Library Instantiation Software Framework"
  homepage "https://github.com/flame/blis"
  url "https://github.com/flame/blis/archive/0.7.0.tar.gz"
  sha256 "7e345d666799e15bba570bd125f97042f17bf752a61dcf314486a6cd096d5f68"
  license "BSD-3-Clause"
  head "https://github.com/flame/blis.git"

  bottle do
    cellar :any
    sha256 "8ac1fb34cdaad5dfdac2e3ac454de08e7ff2a165571554f0bfd665ab2e5f2a71" => :catalina
    sha256 "2ab25f7e90a115e604a5233420b190c7ab60c73642f6eedc3b519f96d20c7bc2" => :mojave
    sha256 "4f19883538758550e8a0ce958d661e186b42cd8af66d6671e3589c30a6e96e14" => :high_sierra
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
