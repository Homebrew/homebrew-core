class Blis < Formula
  desc "BLAS-like Library Instantiation Software Framework"
  homepage "https://github.com/flame/blis"
  url "https://github.com/flame/blis/archive/0.9.0.tar.gz"
  sha256 "1135f664be7355427b91025075562805cdc6cc730d3173f83533b2c5dcc2f308"
  license "BSD-3-Clause"
  head "https://github.com/flame/blis.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "103cdd90012dd567134b27ed704d763a04d3b1d628e3cea3c17106f5efabc640"
    sha256 cellar: :any,                 arm64_monterey: "b00ba6ef35a226e90b0bfdf30d7a89ba81d00305fa8d960ccb6fd0aac63d3925"
    sha256 cellar: :any,                 arm64_big_sur:  "b7bf20b1149ef17db68e5e5626f258e8369f00dbbb22be6c752c298138177aef"
    sha256 cellar: :any,                 ventura:        "dcec254cbee261d15eebc4d3bd8d698f8af275886c9aca7bb4ce3dc0da961437"
    sha256 cellar: :any,                 monterey:       "08dc73c2cbce4359b51c2a4c4f78df6350aa24df087b0c1613bb9995717edd68"
    sha256 cellar: :any,                 big_sur:        "0c21276af8ad03e16deaed43bc146f57aec908e6e4bc95f748cedf2af8c1d3c0"
    sha256 cellar: :any,                 catalina:       "1feac3394dab398ede9e1540b84c4782ee6e7b916e93327ec68324d1d451db17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caf7db98c4ec255521ef31d28156bac9f2149ff02be40ad978b6be0c32ac2ba8"
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
