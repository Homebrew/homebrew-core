class Blis < Formula
  desc "BLAS-like Library Instantiation Software Framework"
  homepage "https://github.com/flame/blis"
  url "https://github.com/flame/blis/archive/refs/tags/2.0.tar.gz"
  sha256 "08bbebd77914a6d1a43874ae5ec2f54fe6a77cba745f2532df28361b0f1ad1b3"
  license "BSD-3-Clause"
  head "https://github.com/flame/blis.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ae5b40dcc1bb83dcc0742f24a1bfe0991bc3a349d34aa329a0b12f88b2b880fe"
    sha256 cellar: :any,                 arm64_sequoia: "461fd80b3bd293dffab9b1a1ed90a35ef4c9b2f6f3546bc44fa06411681871dd"
    sha256 cellar: :any,                 arm64_sonoma:  "91e2bd552c5f1df187fdee979635b0c87ce5ea700127ec2110ef16da2ea005dd"
    sha256 cellar: :any,                 sonoma:        "a6f83d702d2ca94890919df8c80e998a874846677d9c6131358e10f5c03bdb35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c654866bff3d54735f76b81eb0318d3d85727b3224c84c95f7e4a3db851593b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f201ae6efcebd05d84ae5360d95bffa2871344f6384a92be7019948429704776"
  end

  uses_from_macos "python" => :build

  on_macos do
    depends_on "libomp"
    patch :DATA # patch to use libomp when CC=clang as common.mk is installed
  end

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

    system "./configure", "--prefix=#{prefix}", "--enable-cblas", "--enable-threading=openmp", config
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

__END__
--- a/common.mk
+++ b/common.mk
@@ -989,8 +989,8 @@ ifeq ($(CC_VENDOR),clang)
 #THREADING_MODEL := pthreads
 #endif
 ifneq ($(findstring openmp,$(THREADING_MODEL)),)
-CTHREADFLAGS += -fopenmp
-LDFLAGS      += -fopenmp
+CTHREADFLAGS += -I@@HOMEBREW_PREFIX@@/opt/libomp/include -Xpreprocessor -fopenmp
+LDFLAGS      += -L@@HOMEBREW_PREFIX@@/opt/libomp/lib -lomp
 endif
 ifneq ($(findstring pthreads,$(THREADING_MODEL)),)
 CTHREADFLAGS += -pthread
