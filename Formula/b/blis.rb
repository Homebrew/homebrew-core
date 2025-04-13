class Blis < Formula
  desc "BLAS-like Library Instantiation Software Framework"
  homepage "https://github.com/flame/blis"
  url "https://github.com/flame/blis/archive/refs/tags/1.1.tar.gz"
  sha256 "847c035809b8994c077ade737a4813601db96c4cf0d903d08ba6a9b8ee0fe03e"
  license "BSD-3-Clause"
  head "https://github.com/flame/blis.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7b54027b039fa551a50e4fb6e99c79f732a5b34aff78092d733e22c823450ad9"
    sha256 cellar: :any,                 arm64_sonoma:  "0709aa01695e7ce672d9d8a0780d28fa3465f2cba5b49f976bd3c96f498c1448"
    sha256 cellar: :any,                 arm64_ventura: "9630f05d848259bc7ffc9df96102b9655a0cd3284057dd77a5e59256b81a32ec"
    sha256 cellar: :any,                 sonoma:        "eb365f3d3d6fc8eb1df33f83f72b88ee33984438392b78bdc58e4657f7cec66b"
    sha256 cellar: :any,                 ventura:       "996841f0627e6a5f43d4f272bb0698e7fecb9f958fe05915c85b0814a6be34ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9a2bf0a115a4af35026be884519a3b23e97535f5ffcedff0ae7a7a8582914b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db5d4aed1ccf53d93eb65d37dd22cda09f5049e7c5fe4bd2f7db556ccaa57ad3"
  end

  uses_from_macos "python" => :build

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
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "-o", "test", "test.c", "-I#{include}", "-L#{lib}", "-lblis", "-lm"
    system "./test"
  end
end
