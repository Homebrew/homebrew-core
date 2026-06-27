class Blis < Formula
  desc "BLAS-like Library Instantiation Software Framework"
  homepage "https://github.com/flame/blis"
  url "https://github.com/flame/blis/archive/refs/tags/2.1.tar.gz"
  sha256 "901752ec596cd63421ea45a6a06a9f34491cf5ae01cea412ece05f97a2690a96"
  license "BSD-3-Clause"
  head "https://github.com/flame/blis.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "eb82b90d8772853e56be25aa8c8ab53ca9378484af0bc260b0bb84792a1e6f54"
    sha256 cellar: :any, arm64_sequoia: "b9530200988e2f17b9881324ff720797dfb759aa064d325b08e53801a45de530"
    sha256 cellar: :any, arm64_sonoma:  "e1e423ed3af90933a6127ac8867257ad05bb9b77a7f31ee362900b15b4157719"
    sha256 cellar: :any, sonoma:        "bbe516deb23acff84d3e05d466e331afc1d663b62716d3452af37638485437a3"
    sha256 cellar: :any, arm64_linux:   "bf73e717b2c78f38286778783b86998b8f4ef5ad83f11a5b13f0895c045bd4ee"
    sha256 cellar: :any, x86_64_linux:  "0463fc214ea183ee8012fae2439c75820173e2c9107bc5e7b76c99421f6f9fbf"
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
