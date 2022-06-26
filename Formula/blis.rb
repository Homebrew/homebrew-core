class Blis < Formula
  desc "BLAS-like Library Instantiation Software Framework"
  homepage "https://github.com/flame/blis"
  url "https://github.com/flame/blis/archive/0.9.0.tar.gz"
  sha256 "1135f664be7355427b91025075562805cdc6cc730d3173f83533b2c5dcc2f308"
  license "BSD-3-Clause"
  head "https://github.com/flame/blis.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "52c3918675fa0604bf2c9426f0908f5f3e1a25b60f886f86b2ae83ee8b72d7e2"
    sha256 cellar: :any,                 arm64_big_sur:  "a9a11b09c4570cdcc7e84f992a33cab3f41daa27ef1ccc8483d9c2b5c34d6ac6"
    sha256 cellar: :any,                 monterey:       "5b33bda9771e26c111a0b584995e3894c7f9fda16f3eb376e63698a0c6583874"
    sha256 cellar: :any,                 big_sur:        "814f573e8a13d58d4bce3327c97af8dbfa4729dff01d541f2845734640d58a1f"
    sha256 cellar: :any,                 catalina:       "9863e7c187fb4d14bce8499d86a63935c8e04bd76e001f8888f83101cb02feff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6319286075b6b686052882db10b2146275d746bd34235acb881e3c41acf82ebd"
  end

  uses_from_macos "python" => :build

  on_linux do
    depends_on "gcc" => [:build, :test]
  end

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
