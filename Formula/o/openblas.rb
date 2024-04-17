class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/refs/tags/v0.3.27.tar.gz"
  sha256 "aa2d68b1564fe2b13bc292672608e9cdeeeb6dc34995512e65c3b10f4599e897"
  license "BSD-3-Clause"
  head "https://github.com/xianyi/OpenBLAS.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "688a3083556bf2e30e61c25946e964034eeebf6389b9448c2a265fb066da85a4"
    sha256 cellar: :any,                 arm64_ventura:  "229ee2c93cc2c494fd2e2aafe435e8693cd78ab9c4512c28e670c8751c139c3f"
    sha256 cellar: :any,                 arm64_monterey: "c593af5b8c4bbbc527e6bd3379ca145166ab72501cef4913619814bd452ce03c"
    sha256 cellar: :any,                 sonoma:         "d82fbe39707da31931cbb3e9e368555a1988da1da69cabe35ca9486b4a6914d8"
    sha256 cellar: :any,                 ventura:        "14252c66641b8d914997b97d7c59af4a97055332c0450fc2de5dbf92723d3951"
    sha256 cellar: :any,                 monterey:       "8edde94071a31efc54795ab1b6c30ccf7ea37c8cbbd54fc2722c0cf123d3c9ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0d7243463fc8791199c3617be2eae1462679c23ecfd5352d10bf03570d9a71c"
  end

  keg_only :shadowed_by_macos, "macOS provides BLAS in Accelerate.framework"

  depends_on "gcc" # for gfortran
  fails_with :clang

  def install
    ENV.runtime_cpu_detection
    ENV.deparallelize # build is parallel by default, but setting -j confuses it

    # The build log has many warnings of macOS build version mismatches.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?
    ENV["DYNAMIC_ARCH"] = "1"
    ENV["USE_OPENMP"] = "1"
    # Force a large NUM_THREADS to support larger Macs than the VMs that build the bottles
    ENV["NUM_THREADS"] = "56"
    # See available targets in TargetList.txt
    ENV["TARGET"] = case Hardware.oldest_cpu
    when :arm_vortex_tempest
      "VORTEX"
    when :westmere
      "NEHALEM"
    else
      Hardware.oldest_cpu.upcase.to_s
    end

    # Apple Silicon does not support SVE
    # https://github.com/xianyi/OpenBLAS/issues/4212
    ENV["NO_SVE"] = "1" if Hardware::CPU.arm?

    # Must call in two steps
    system "make", "CC=#{ENV.cc}", "FC=gfortran", "libs", "netlib", "shared"
    system "make", "PREFIX=#{prefix}", "install"

    lib.install_symlink shared_library("libopenblas") => shared_library("libblas")
    lib.install_symlink shared_library("libopenblas") => shared_library("liblapack")
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <math.h>
      #include "cblas.h"

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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lopenblas",
                   "-o", "test"
    system "./test"
  end
end
