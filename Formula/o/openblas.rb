class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  url "https://github.com/OpenMathLib/OpenBLAS/archive/refs/tags/v0.3.28.tar.gz"
  sha256 "f1003466ad074e9b0c8d421a204121100b0751c96fc6fcf3d1456bd12f8a00a1"
  # The main license is BSD-3-Clause. Additionally,
  # 1. OpenBLAS is based on GotoBLAS2 so some code is under original BSD-2-Clause-Views
  # 2. lapack-netlib/ is a bundled LAPACK so it is BSD-3-Clause-Open-MPI
  # 3. interface/{gemmt.c,sbgemmt.c} is BSD-2-Clause
  # 4. relapack/ is MIT but license is omitted as it is not enabled
  license all_of: ["BSD-3-Clause", "BSD-2-Clause-Views", "BSD-3-Clause-Open-MPI", "BSD-2-Clause"]
  head "https://github.com/OpenMathLib/OpenBLAS.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8d319fccf7a06b8f0540d8cb864a1fbdcde99f5b2c57574b8effc52bd5cf2faf"
    sha256 cellar: :any,                 arm64_sonoma:   "0f31a93b4161cf8a6bb9cda77dd41c5285327920e75ef091e587a6f9ed74446e"
    sha256 cellar: :any,                 arm64_ventura:  "542382c256f30f672e9b2006afb65864ae59383ec80432e2b0dcfd0bda797e82"
    sha256 cellar: :any,                 arm64_monterey: "b0582fc465c1cd001d994b11efd60b54f47bd8d39ace6a53a289c81e7f6f99c5"
    sha256 cellar: :any,                 sonoma:         "0ff27b7fa21c56961fcf37d0b4690e843b0ce8e5f967a73223e4b247fa462b1c"
    sha256 cellar: :any,                 ventura:        "b11f8a96fff66cbdff06a79c5920163185ebc40abf670a90a677156144d3a80a"
    sha256 cellar: :any,                 monterey:       "569b39c70b716df30d30334d2b5715eba0574a5f28c2316931736e776326aecb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ac6e26f577d71f531bd0f268616ad2aa845c3c2843154b6206e7a293f017100"
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
