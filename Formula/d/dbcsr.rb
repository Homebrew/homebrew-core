class Dbcsr < Formula
  desc "Distributed Block Compressed Sparse Row matrix library"
  homepage "https://cp2k.github.io/dbcsr/"
  url "https://github.com/cp2k/dbcsr/releases/download/v2.10.0/dbcsr-2.10.0.tar.gz"
  sha256 "3d897220fbb4498215331efad6905eb7744881b4cf04eb5c5fb4db7c48a56ef9"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "24e1669b0c5787d34b3be316f0ce4225023dc5c2c0b99d05c738ff95fac9c99c"
    sha256 cellar: :any, arm64_tahoe:       "c4cb0c2df34a6a58232b42b9f8d3a45b41ffb2bdd64fa9a2d8c4dd4b5e3dd751"
    sha256 cellar: :any, arm64_sequoia:     "08dc2f7403b390e6075f787418dec44ee36715b8969800f0b67a5f1dba529e7e"
    sha256 cellar: :any, arm64_linux:       "cc96409550cbbefd6e5aa54745fdb572c8dfa0563c48b84f7147d52916db8391"
    sha256 cellar: :any, x86_64_linux:      "117e28b08638f6f6b4ebd9cc12fc04d94856bd03b6d5bb390acb4f6f249933fd"
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

  # Export C API from PRIVATE modules, hidden by gfortran 16.2 (GCC PR126872)
  patch do
    url "https://github.com/cp2k/dbcsr/commit/a5d9bcfcd487e3181b981687334da1b89bc61dce.patch?full_index=1"
    sha256 "c0f0f43eb108e12076079cbe59d0a9afe486f729bcfb94f4c61b721e093018fc"
    type :backport
    resolves "https://github.com/cp2k/dbcsr/pull/1027"
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
