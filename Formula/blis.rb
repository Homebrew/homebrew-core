class Blis < Formula
  desc "BLAS-like Library Instantiation Software Framework"
  homepage "https://github.com/flame/blis"
  url "https://github.com/flame/blis/archive/0.8.1.tar.gz"
  sha256 "729694128719801e82fae7b5f2489ab73e4a467f46271beff09588c9265a697b"
  license "BSD-3-Clause"
  head "https://github.com/flame/blis.git"

  bottle do
    sha256 cellar: :any, big_sur:  "ad2e6862fd4b5a425769c108e7a36e33ac7e7fc77ce699756fe051e68524518d"
    sha256 cellar: :any, catalina: "b26e5e7deb7b85319fa539a061ff84df842378a902e3695a4f6df63eba9f5cdb"
    sha256 cellar: :any, mojave:   "333cceec593098d68f438ddcfc6415d44cf0af565601c0163496e23bdf4a8aec"
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
