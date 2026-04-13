class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  url "https://github.com/OpenMathLib/OpenBLAS/archive/refs/tags/v0.3.32.tar.gz"
  sha256 "f8a1138e01fddca9e4c29f9684fd570ba39dedc9ca76055e1425d5d4b1a4a766"
  # The main license is BSD-3-Clause. Additionally,
  # 1. OpenBLAS is based on GotoBLAS2 so some code is under original BSD-2-Clause-Views
  # 2. lapack-netlib/ is a bundled LAPACK so it is BSD-3-Clause-Open-MPI
  # 3. interface/{gemmt.c,sbgemmt.c} is BSD-2-Clause
  # 4. relapack/ is MIT but license is omitted as it is not enabled
  license all_of: ["BSD-3-Clause", "BSD-2-Clause-Views", "BSD-3-Clause-Open-MPI", "BSD-2-Clause"]
  compatibility_version 1
  head "https://github.com/OpenMathLib/OpenBLAS.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "29eb2c60bfb1f91c2dac337388d129eace6c2524719596ec147049341c4b41b7"
    sha256 cellar: :any,                 arm64_sequoia: "df3b3824787ae0c7ec29dd7c2c296be806b32288c9e473af5a53c3bb05df5f46"
    sha256 cellar: :any,                 arm64_sonoma:  "e101655759fa93327500c3957a20b92786b0723bf3100473cc552652b03bb39a"
    sha256 cellar: :any,                 sonoma:        "f9c7ab040f30722b194ffce84f60d76440b2483f2d758af4d75bf67cc4685aa7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b209d541ac5ebe6b380514a4d27fdb9400ff1a11b85cb0d396b70a6dd0af0691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8750692a5e3a4e469c028c1edb2ac050ae42f66ddcc86d0a8c81443362eec67c"
  end

  keg_only :shadowed_by_macos, "macOS provides BLAS in Accelerate.framework"

  depends_on "pkgconf" => :test
  depends_on "gcc" # for gfortran

  on_macos do
    depends_on "libomp"
  end

  def install
    # Workaround to use Apple Clang, GCC gfortran and link to `libomp`. We do not
    # want to link GCC's libgomp as it will cause dependents to mix multiple OpenMP:
    # https://cpufun.substack.com/p/is-mixing-openmp-runtimes-safe
    if ENV.compiler == :clang
      inreplace "Makefile.install" do |s|
        s.gsub! ":= -fopenmp", ":= -I#{Formula["libomp"].opt_include} -Xpreprocessor -fopenmp"
        s.gsub! "+= -lgomp", "+= -L#{Formula["libomp"].opt_lib} -lomp"
      end
      inreplace "Makefile.system" do |s|
        s.gsub! "+= -fopenmp", "+= -Xpreprocessor -fopenmp"
        s.gsub! "+= -lgfortran", "+= -L#{Formula["gcc"].opt_lib}/gcc/current -lgfortran"
      end
    end

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
    # https://github.com/OpenMathLib/OpenBLAS/issues/4212
    ENV["NO_SVE"] = "1" if Hardware::CPU.arm?

    # Must call in two steps
    system "make", "CC=#{ENV.cc}", "FC=gfortran", "libs", "netlib", "shared"
    system "make", "PREFIX=#{prefix}", "install"

    lib.install_symlink shared_library("libopenblas") => shared_library("libblas")
    lib.install_symlink shared_library("libopenblas") => shared_library("liblapack")
    pkgshare.install "cpp_thread_test"
  end

  test do
    if OS.mac?
      require "utils/linkage"
      libgomp = Formula["gcc"].opt_lib/"gcc/current/libgomp.dylib"
      libomp = Formula["libomp"].opt_lib/"libomp.dylib"
      refute Utils.binary_linked_to_library?(lib/"libopenblas.dylib", libgomp), "Unwanted linkage to libgomp!"
      assert Utils.binary_linked_to_library?(lib/"libopenblas.dylib", libomp), "Missing linkage to libomp!"
    end

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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lopenblas", "-o", "test"
    system "./test"

    cp_r pkgshare/"cpp_thread_test/.", testpath
    ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig" if OS.mac?
    flags = shell_output("pkgconf --cflags --libs openblas").chomp.split
    flags += %W[-L#{Formula["libomp"].lib} -lomp] if OS.mac?

    %w[dgemm_thread_safety dgemv_thread_safety].each do |test|
      inreplace "#{test}.cpp", '"../cblas.h"', '"cblas.h"'
      system ENV.cxx, *ENV.cxxflags.to_s.split, "-std=c++11", "#{test}.cpp", "-o", test, *flags
      system "./#{test}"
    end
  end
end
