class Blis < Formula
  desc "BLAS-like Library Instantiation Software Framework"
  homepage "https://github.com/flame/blis"
  url "https://github.com/flame/blis/archive/refs/tags/1.0.tar.gz"
  sha256 "9c12972aa1e50f64ca61684eba6828f2f3dd509384b1e41a1e8a9aedea4b16a6"
  license "BSD-3-Clause"
  head "https://github.com/flame/blis.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "01f6d68c4778655be5f5b5bae6952e5a6979e665c679daa3a39a3e93392d554d"
    sha256 cellar: :any,                 arm64_sonoma:   "1d2a10987101529132b5b6ff330ae2b267cb724b4c647e995cdfeffafe7f66c4"
    sha256 cellar: :any,                 arm64_ventura:  "fe6a791c00a37f507387293ad0dcbe87e75d93e6bbf74bcd8df9ab431d318f02"
    sha256 cellar: :any,                 arm64_monterey: "a65ab186fb8c72a6e7c9bbe01f84c916e8ef841e3f91759a4b32f663df2e0723"
    sha256 cellar: :any,                 sonoma:         "fa0c1fb994eebe51d4154c880e69508c6b24b28f37f73d66e7da75ba1e1978fe"
    sha256 cellar: :any,                 ventura:        "65277d9faaa9a63cca586c9979fa271e1c62f14bd5a8113d814a8a85c1eb6ec8"
    sha256 cellar: :any,                 monterey:       "021d57eed83f4d50a681d37d091b310449572e24fdcbbdbae14e39127376bc3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c712e39e529db5de74f13c5c28c8645d01c1791bb1489308419a101c8e9ee627"
  end

  uses_from_macos "python" => :build

  fails_with gcc: "5"

  def install
    # https://github.com/flame/blis/blob/master/docs/ConfigurationHowTo.md
    ENV.runtime_cpu_detection
    config = if !build.bottle?
      "auto"
    elsif OS.mac?
      # For Apple Silicon, we can optimize using the dedicated "firestorm" config.
      # For Intel Macs, we build multiple Intel x86_64 to allow runtime optimization.
      Hardware::CPU.arm? ? "firestorm" : "intel64"
    else
      # For x86_64 Linux, we build full "x86_64" family with Intel and AMD processors.
      Hardware::CPU.arch
    end

    system "./configure", "--prefix=#{prefix}", "--enable-cblas", config
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
