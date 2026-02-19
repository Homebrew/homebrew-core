class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  url "https://github.com/OpenMathLib/OpenBLAS/archive/refs/tags/v0.3.31.tar.gz"
  sha256 "6dd2a63ac9d32643b7cc636eab57bf4e57d0ed1fff926dfbc5d3d97f2d2be3a6"
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
    sha256 cellar: :any,                 arm64_tahoe:   "86be8c9ee5070d3b4e940ab72cd89998dcf59ece4691d7b3bc2a9549f3999d31"
    sha256 cellar: :any,                 arm64_sequoia: "fcde181971556b1ef2febf3051c4365c2138e5be4b81c44b14ebf642a7aa0bd2"
    sha256 cellar: :any,                 arm64_sonoma:  "a29ae64872e453f299745202b9cdcad7d9479b00af47528d80d3ce068b0bb80d"
    sha256 cellar: :any,                 sonoma:        "b44311b4806a899fb976c6e7f9369ef1a8f913324f32b2b631dd7bcac2dd93fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcaadf5e964f6c0de691cf40697b9a0981926396a8fd5a2253db7fe4dd006a3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df4ff7c931ea08422354e0d8dcd1efb84144b91393ec58572434483a154f6bbf"
  end

  keg_only :shadowed_by_macos, "macOS provides BLAS in Accelerate.framework"

  depends_on "pkgconf" => :test
  depends_on "gcc" # for gfortran

  on_macos do
    depends_on "libomp"
  end

  # Fix configuration header on Linux Arm with GCC 12
  # https://github.com/OpenMathLib/OpenBLAS/pull/5606
  patch do
    url "https://github.com/OpenMathLib/OpenBLAS/commit/c077708852c7262b6bc0da6bc094b447e7ba7b3c.patch?full_index=1"
    sha256 "e59596a7bec1fa6c22c4bee20c8040faa15fa57aa6486acd99b9688aef15f4da"
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
