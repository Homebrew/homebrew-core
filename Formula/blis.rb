class Blis < Formula
  desc "BLAS-like Library Instantiation Software Framework"
  homepage "https://github.com/flame/blis"
  url "https://github.com/flame/blis/archive/0.8.0.tar.gz"
  sha256 "5e05868c4a6cf5032a7492f8861653e939a8f907a4fa524bbb6e14394e170a3d"
  license "BSD-3-Clause"
  head "https://github.com/flame/blis.git"

  bottle do
    cellar :any
    sha256 "2e70e19be54e6996848fdce52de417d9b657e8b1c73786d716e77aa2f55e31f8" => :big_sur
    sha256 "8cf27cca34ada36f300cfea6abc844a01644930b4a416edee439dd58ef04b36d" => :catalina
    sha256 "d5e0edecffeaff6b7ffb80d3e3657e68518d420e7b9f1517cf98539f297ec096" => :mojave
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
