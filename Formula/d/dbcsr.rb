class Dbcsr < Formula
  desc "Distributed Block Compressed Sparse Row matrix library"
  homepage "https://cp2k.github.io/dbcsr/"
  url "https://github.com/cp2k/dbcsr/releases/download/v2.10.0/dbcsr-2.10.0.tar.gz"
  sha256 "3d897220fbb4498215331efad6905eb7744881b4cf04eb5c5fb4db7c48a56ef9"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c5798454cbb086db2eb403c97e99e4ca0e1ad983cc681af0e79b27ed2acbd2b9"
    sha256 cellar: :any, arm64_sequoia: "b1c5d55767155b2079b91757aa030e8ff1c80afe2e7ab6dcaa34fd472c6bb1b6"
    sha256 cellar: :any, arm64_sonoma:  "9d6310a8cb87492dee2e34d86d174d46d219a19873d62fe483ecbcf5572b98b6"
    sha256 cellar: :any, sonoma:        "a43110decec753e33f4c1ee54d0f5d27b08e61c43e75aaf5d3d76e41a3ac76ca"
    sha256 cellar: :any, arm64_linux:   "637d0f8cb9bd89c311c1c3715ba6cff6d9476e7e870eba5caef96ad35fac1d31"
    sha256 cellar: :any, x86_64_linux:  "8ccb25d53cd0fc7d0c6758a4271cd2f75994ab6f10ad288303c6e30ed49faf6a"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "fypp" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
    rm_r("tools/build_utils/fypp")

    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DUSE_MPI=ON
      -DUSE_MPI_F08=ON
      -DUSE_SMM=blas
      -DWITH_EXAMPLES=OFF
    ]
    if OS.mac?
      args += %W[
        -DOpenMP_Fortran_LIB_NAMES=omp
        -DOpenMP_omp_LIBRARY=#{formula_opt_lib("libomp")}/libomp.dylib
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples/dbcsr_example_3.cpp", "examples/dbcsr_example_3.F"
  end

  test do
    if OS.mac?
      require "utils/linkage"
      libgomp = formula_opt_lib("gcc")/"gcc/current/libgomp.dylib"
      refute Utils.binary_linked_to_library?(lib/"libdbcsr.dylib", libgomp), "Unwanted linkage to libgomp!"
      ENV.append_path "CMAKE_PREFIX_PATH", formula_opt_prefix("libomp")
    end

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test LANGUAGES Fortran C CXX)
      set(CMAKE_CXX_STANDARD 14)

      find_package(DBCSR CONFIG REQUIRED)
      find_package(MPI)

      set(CMAKE_Fortran_FLAGS "-ffree-form")
      add_executable(dbcsr_example_fortran #{pkgshare}/dbcsr_example_3.F)
      target_link_libraries(dbcsr_example_fortran DBCSR::dbcsr)

      add_executable(dbcsr_example_cpp #{pkgshare}/dbcsr_example_3.cpp)
      target_link_libraries(dbcsr_example_cpp DBCSR::dbcsr_c MPI::MPI_CXX)
    CMAKE

    system "cmake", "-S", ".", "-B", ".", "-DCMAKE_BUILD_RPATH=#{lib}"
    system "cmake", "--build", "."
    system "mpirun", "./dbcsr_example_fortran"
    system "mpirun", "./dbcsr_example_cpp"
  end
end
