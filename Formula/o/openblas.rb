class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  url "https://github.com/OpenMathLib/OpenBLAS/archive/refs/tags/v0.3.34.tar.gz"
  sha256 "cd7e129868320cc2d033afa920e31202dfe0b8066a5b66661900ccc0f197dfed"
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
    sha256 cellar: :any, arm64_tahoe:   "8cc0a53629065fb114b2e9514d03c661764ef6b40607a273267e86d5086253f7"
    sha256 cellar: :any, arm64_sequoia: "779aa71127f0c6ce10db5f68a0a00fbeccb9146c4a2889d0f423d538fb9d4f60"
    sha256 cellar: :any, arm64_sonoma:  "ef33d12414f3620418459bbe9899642a0664f7199daca8a3e762ed1423796618"
    sha256 cellar: :any, sonoma:        "bcd874fc9ec787f6196278aded086a6100424af3b8def4105d9aaf479604087b"
    sha256 cellar: :any, arm64_linux:   "f6041cf31f7603cb7c67c61e3cf8418a2640f05e88ee00596efef5c805d344aa"
    sha256 cellar: :any, x86_64_linux:  "e144980ce9ba119e05b4683cda44ac25e6ac01e5cdb550fc9ae404959ce0522c"
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
        s.gsub! ":= -fopenmp", ":= -I#{formula_opt_include("libomp")} -Xpreprocessor -fopenmp"
        s.gsub! "+= -lgomp", "+= -L#{formula_opt_lib("libomp")} -lomp"
      end
      inreplace "Makefile.system" do |s|
        s.gsub! "+= -fopenmp", "+= -Xpreprocessor -fopenmp"
        s.gsub! "+= -lgfortran", "+= -L#{formula_opt_lib("gcc")}/gcc/current -lgfortran"
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
      libgomp = formula_opt_lib("gcc")/"gcc/current/libgomp.dylib"
      libomp = formula_opt_lib("libomp")/"libomp.dylib"
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
