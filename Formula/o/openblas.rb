class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  url "https://github.com/OpenMathLib/OpenBLAS/releases/download/v0.3.30/OpenBLAS-0.3.30.tar.gz"
  sha256 "27342cff518646afb4c2b976d809102e368957974c250a25ccc965e53063c95d"
  # The main license is BSD-3-Clause. Additionally,
  # 1. OpenBLAS is based on GotoBLAS2 so some code is under original BSD-2-Clause-Views
  # 2. lapack-netlib/ is a bundled LAPACK so it is BSD-3-Clause-Open-MPI
  # 3. interface/{gemmt.c,sbgemmt.c} is BSD-2-Clause
  # 4. relapack/ is MIT but license is omitted as it is not enabled
  license all_of: ["BSD-3-Clause", "BSD-2-Clause-Views", "BSD-3-Clause-Open-MPI", "BSD-2-Clause"]
  revision 1
  head "https://github.com/OpenMathLib/OpenBLAS.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "a25af8ac88166d74dcea256b9ee9ffaad0c5ace88941a3e760d32aa3813e778c"
    sha256 cellar: :any,                 arm64_sequoia: "f194baff998d5d4418c0a647f592f14c10f8c26cd1542f64b310ac72844a095a"
    sha256 cellar: :any,                 arm64_sonoma:  "46471ce1e3f44f4c765bb6fad1690a9aa69fe9c948379e6f40b9c5e38652c4b9"
    sha256 cellar: :any,                 arm64_ventura: "0b711f2254dc6c5ce89d21cba9f67d89da72b3cfe55bb840f4130dd2bab62fd6"
    sha256 cellar: :any,                 sonoma:        "dcef53fdbfa90411375b209ac11ae5b41e6c63f9f139e155d892bb2e4616feb6"
    sha256 cellar: :any,                 ventura:       "ebd50b45068b81d33f2269f523ade1e357a230234ef27524a37365de0b657580"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60f63379659c38cea3a544c5e85e612ce0a0d02433aeb581fce3e1264f909eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08c0a5b778704cdfbf09b0db18a87cbfc2ba2a82241d2d999488a771cb308447"
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
      args << "-DOpenMP_Fortran_LIB_NAMES=omp"
      args << "-DOpenMP_omp_LIBRARY=#{Formula["libomp"].opt_lib}/libomp.dylib"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    lib.install_symlink shared_library("libopenblas") => shared_library("libblas")
    lib.install_symlink shared_library("libopenblas") => shared_library("liblapack")
    pkgshare.install "cpp_thread_test"

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

    ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig" if OS.mac?
    flags = shell_output("pkgconf --cflags --libs openblas").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    flags += %W[-I#{Formula["libomp"].opt_include} -L#{Formula["libomp"].opt_lib} -lomp] if OS.mac?
    cp_r pkgshare/"cpp_thread_test/.", testpath
    %w[dgemm_thread_safety dgemv_thread_safety].each do |test|
      inreplace "#{test}.cpp", '"../cblas.h"', '"cblas.h"'
      system ENV.cxx, *ENV.cxxflags.to_s.split, "-std=c++11", "#{test}.cpp", "-o", test, *flags
      system "./#{test}"
    end
  end
end
