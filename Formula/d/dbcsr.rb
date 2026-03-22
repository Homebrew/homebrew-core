class Dbcsr < Formula
  desc "Distributed Block Compressed Sparse Row matrix library"
  homepage "https://cp2k.github.io/dbcsr/"
  url "https://github.com/cp2k/dbcsr/releases/download/v2.9.1/dbcsr-2.9.1.tar.gz"
  sha256 "fa5a4aeba0a07761511af2c26c779bd811b5ea0ef06a5d94535b6dd7b2e0ce59"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2baae452ccf21e43a44b6ce2ad134398d68472651d9d27a4b8e95b4a56a9e269"
    sha256 cellar: :any,                 arm64_sequoia: "e7efc269f64b82c1e2bcebb2e13f9c467ef9d410a25e83301414eeb8d98ee350"
    sha256 cellar: :any,                 arm64_sonoma:  "d3bfb3075c5772492e86c5a0b15252b9eef61a8ec407cdf0ae4f5ef45041957c"
    sha256 cellar: :any,                 sonoma:        "c7b10954c91ef37a3baba264687e88b5ccf0256244ec0ec5ffc701ee3305818e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c69b78b719f7d8332acf627f943b7befbbdf7645b11bee16b5bc7939c677f7ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79dbffe498816deaada338e25d783eb51ff6338e2b6df63e1a3c48cc21fce0a0"
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
        -DOpenMP_omp_LIBRARY=#{Formula["libomp"].opt_lib}/libomp.dylib
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
      libgomp = Formula["gcc"].opt_lib/"gcc/current/libgomp.dylib"
      refute Utils.binary_linked_to_library?(lib/"libdbcsr.dylib", libgomp), "Unwanted linkage to libgomp!"
      ENV.append_path "CMAKE_PREFIX_PATH", Formula["libomp"].opt_prefix
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
