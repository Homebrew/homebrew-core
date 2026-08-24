class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https://www.cp2k.org/"
  url "https://github.com/cp2k/cp2k/releases/download/v2026.2/cp2k-2026.2.tar.bz2"
  sha256 "f9bd86f580f57a53a0768c0045d1417f9f9a1d66d851ed7f662f496200043373"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "1f620938be50bc0d11008196f8bf5753c898403e8fcada96a90f7834e238ed58"
    sha256 arm64_sequoia: "5162daa2c7b513221e36306165fc9b6a706e3252c92c463a45a792cafd4d0573"
    sha256 arm64_sonoma:  "2f6867d95c43533e39d60db7459f4483f0dc82e3d5c3f417689d33fb1ebe2132"
    sha256 sonoma:        "5303b0a4f6d783ab6d074536d54ea52f2738f596ff43d8a1bc399b4ca6b545f9"
    sha256 arm64_linux:   "2be5d917d067209333974a1e7efb377b639709a71a3b317b9988920844942579"
    sha256 x86_64_linux:  "9190e9449a9cf4f3a519b1b34e7f0da5335f4b93d28a8b07fd229d2e36dadc9f"
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
      -DCMAKE_INSTALL_LIBDIR=#{lib}
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
        -DOpenMP_omp_LIBRARY=#{formula_opt_lib("libomp")}/libomp.dylib
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args.reject { |s| s["CMAKE_INSTALL_LIBDIR"] }
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"tests").install "tests/Fist/water.inp"
  end

  test do
    if OS.mac?
      require "utils/linkage"
      libgomp = formula_opt_lib("gcc")/"gcc/current/libgomp.dylib"
      refute Utils.binary_linked_to_library?(lib/"libcp2k.dylib", libgomp), "Unwanted linkage to libgomp!"
    end

    system Formula["open-mpi"].bin/"mpirun", bin/"cp2k.psmp", pkgshare/"tests/water.inp"
  end
end
