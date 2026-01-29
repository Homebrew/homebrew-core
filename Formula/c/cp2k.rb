class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https://www.cp2k.org/"
  url "https://github.com/cp2k/cp2k/releases/download/v2026.1/cp2k-2026.1.tar.bz2"
  sha256 "4364c74bcffaa474bc234e11686b09550e4d06932acf2147a341e4f7679dd88e"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "7af6ab77ed39609075e8e08c7921f405c024dbf045dde7cf1ce6164aac550fd8"
    sha256 arm64_sequoia: "142ab8353ffe343a3adbb5bc83841a6037f1433379f7371ffa3b97e9ca33b051"
    sha256 arm64_sonoma:  "ff960f844b190cdffe23054a7d234012baf132db17928f2ffa4bb98c8023d946"
    sha256 sonoma:        "2b7c500da363bbb9a7466c1ab3612827803b769b689b55194cb62efbc9074c52"
    sha256 arm64_linux:   "14f388d665962f10f5692d5c280a150b79bc228ad93418e54e8befda5e30c590"
    sha256 x86_64_linux:  "7f19e8f4da26c16b8f3ff8f5a7c8965d6defe54e1212a8a5b20f8be87d0fee9a"
  end

  depends_on "cmake" => :build
  depends_on "fypp" => :build
  depends_on "pkgconf" => :build

  depends_on "dbcsr"
  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "libint"
  depends_on "libxc"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "scalapack"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
    # Avoid over-optimizing fortran code as we don't have a shim for gfortran
    optflags = ENV["HOMEBREW_OPTFLAGS"].to_s.split.join(";")
    inreplace "cmake/CompilerConfiguration.cmake", "-march=native;-mtune=native", optflags

    # Avoid trying to access /proc/self/statm on macOS
    ENV.append "FFLAGS", "-D__NO_STATM_ACCESS" if OS.mac?

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCP2K_BLAS_VENDOR=OpenBLAS
      -DCP2K_USE_FFTW3=ON
      -DCP2K_USE_LIBINT2=ON
      -DCP2K_USE_LIBXC=ON
      -DCP2K_USE_MPI=ON
      -DCP2K_USE_MPI_F08=ON
    ]
    if OS.mac?
      args += %W[
        -DOpenMP_Fortran_LIB_NAMES=omp
        -DOpenMP_omp_LIBRARY=#{Formula["libomp"].opt_lib}/libomp.dylib
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"tests").install "tests/Fist/water.inp"
  end

  test do
    if OS.mac?
      require "utils/linkage"
      libgomp = Formula["gcc"].opt_lib/"gcc/current/libgomp.dylib"
      refute Utils.binary_linked_to_library?(lib/"libcp2k.dylib", libgomp), "Unwanted linkage to libgomp!"
    end

    system Formula["open-mpi"].bin/"mpirun", bin/"cp2k.psmp", pkgshare/"tests/water.inp"
  end
end
