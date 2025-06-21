class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  url "https://github.com/OpenMathLib/OpenBLAS/archive/refs/tags/v0.3.30.tar.gz"
  sha256 "27342cff518646afb4c2b976d809102e368957974c250a25ccc965e53063c95d"
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
    sha256 cellar: :any,                 arm64_sequoia: "19429463a737ea1ca72573210238f7d5000731431a442679d9c00b215722fdbd"
    sha256 cellar: :any,                 arm64_sonoma:  "81233b55f062b049f559ed43f37674648e0b7dfe06a6dc7f776251fc46144811"
    sha256 cellar: :any,                 arm64_ventura: "4351d5aa370ac2f7cb661062b9b272fdf7ef7373d0b2dfe10f5a2c2cf9ffc95b"
    sha256 cellar: :any,                 sonoma:        "0cc19e345f5e4b4f0b32e9dc39247a0f97adbb48c10dd9e4655d00822b1c9539"
    sha256 cellar: :any,                 ventura:       "f6bb911cce1ea42486696f1dfc50bd22c8ec6ce6d972047a7c8ca58778c8d320"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "644c21828d8f3fdaf5d6cabdd815abf71b2bd7446a4a5d9640411fb64028d9a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47a79133b44870b5f5e23c546efb25da93edd4671ba2bd56a1aa43907054df81"
  end

  keg_only :shadowed_by_macos, "macOS provides BLAS in Accelerate.framework"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "gcc" # for gfortran

  on_macos do
    depends_on "libomp"
  end

  def install
    ENV.runtime_cpu_detection

    target = case Hardware.oldest_cpu
    when :arm_vortex_tempest
      "VORTEX"
    when :westmere
      "NEHALEM"
    else
      Hardware.oldest_cpu.upcase.to_s
    end

    args = %W[
      -DUSE_OPENMP=ON
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_STATIC_LIBS=ON
      -DNUM_THREADS=64
      -DTARGET=#{target}
    ]

    args << "-DDYNAMIC_ARCH=ON" if !OS.mac? || Hardware::CPU.intel?

    if OS.mac?
      libomp = Formula["libomp"]
      args << "-DOpenMP_Fortran_LIB_NAMES=omp"
      args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.dylib"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    lib.install_symlink shared_library("libopenblas") => shared_library("libblas")
    lib.install_symlink shared_library("libopenblas") => shared_library("liblapack")

    inreplace lib/"pkgconfig/openblas.pc", prefix, opt_prefix
  end

  test do
    (testpath/"test.c").write <<~C
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
    C

    ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs openblas").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
