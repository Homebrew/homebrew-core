class Dbcsr < Formula
  desc "Distributed Block Compressed Sparse Row matrix library"
  homepage "https://cp2k.github.io/dbcsr/"
  url "https://github.com/cp2k/dbcsr/releases/download/v2.9.1/dbcsr-2.9.1.tar.gz"
  sha256 "fa5a4aeba0a07761511af2c26c779bd811b5ea0ef06a5d94535b6dd7b2e0ce59"
  license "GPL-2.0-or-later"

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
