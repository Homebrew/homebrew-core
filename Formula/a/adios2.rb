class Adios2 < Formula
  desc "Next generation of ADIOS developed in the Exascale Computing Program"
  homepage "https://adios2.readthedocs.io"
  url "https://github.com/ornladios/ADIOS2/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "14cf0bcd94772194bce0f2c0e74dba187965d1cffd12d45f801c32929158579e"
  license "Apache-2.0"
  revision 1
  head "https://github.com/ornladios/ADIOS2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "fb192ffe0a0bc23c4cc56526c9a2b8346e53e5260874cc300bb0a065aeae7418"
    sha256 arm64_sequoia: "61c5f21327298bf1f22d9ecbe76cf663de26fb497d6f627cca61f81757c434ba"
    sha256 arm64_sonoma:  "125c9a9dd992a8fd49fd86481dba54839837a820b65cabc554661a3214c624ef"
    sha256 sonoma:        "5ee13af0760b4bd1832c934036fda68e64ed02b6f0bbc16cab9b7b47205cb1e3"
    sha256 arm64_linux:   "8d3519f6da5495d9fae6f5a090444aaaebbca838dabc5516d52adf12a4ee1109"
    sha256 x86_64_linux:  "cbf4cd5b3bb96bb85cc986f7c74a53323c7b04fde0ab265c30e1dfca5f789b08"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pybind11" => :build
  depends_on "c-blosc2"
  depends_on "gcc" # for gfortran
  depends_on "libfabric"
  depends_on "libpng"
  depends_on "libsodium"
  depends_on "mpi4py"
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "pugixml"
  depends_on "python@3.14"
  depends_on "sqlite"
  depends_on "yaml-cpp"
  depends_on "zeromq"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version == 1400
    depends_on "lz4"
    depends_on "zstd"
  end

  # clang: error: unable to execute command: Segmentation fault: 11
  # clang: error: clang frontend command failed due to signal (use -v to see invocation)
  # Apple clang version 14.0.0 (clang-1400.0.29.202)
  fails_with :clang if DevelopmentTools.clang_build_version == 1400

  def python3
    "python3.14"
  end

  def install
    ENV.llvm_clang if DevelopmentTools.clang_build_version == 1400

    # CMake FortranCInterface_VERIFY fails with LTO on Linux due to different GCC and GFortran versions
    ENV.append "FFLAGS", "-fno-lto" if OS.linux?

    # fix `include/adios2/common/ADIOSConfig.h` file audit failure
    inreplace "source/adios2/common/ADIOSConfig.h.in" do |s|
      s.gsub! ": @CMAKE_C_COMPILER@", ": #{ENV.cc}"
      s.gsub! ": @CMAKE_CXX_COMPILER@", ": #{ENV.cxx}"
    end

    args = %W[
      -DADIOS2_USE_Blosc2=ON
      -DADIOS2_USE_BZip2=ON
      -DADIOS2_USE_DataSpaces=OFF
      -DADIOS2_USE_Fortran=ON
      -DADIOS2_USE_HDF5=OFF
      -DADIOS2_USE_IME=OFF
      -DADIOS2_USE_MGARD=OFF
      -DADIOS2_USE_MPI=ON
      -DADIOS2_USE_PNG=ON
      -DADIOS2_USE_Python=ON
      -DADIOS2_USE_SZ=OFF
      -DADIOS2_USE_ZeroMQ=ON
      -DADIOS2_USE_ZFP=OFF
      -DCMAKE_DISABLE_FIND_PACKAGE_BISON=TRUE
      -DCMAKE_DISABLE_FIND_PACKAGE_CrayDRC=TRUE
      -DCMAKE_DISABLE_FIND_PACKAGE_FLEX=TRUE
      -DCMAKE_DISABLE_FIND_PACKAGE_LibFFI=TRUE
      -DCMAKE_DISABLE_FIND_PACKAGE_NVSTREAM=TRUE
      -DPython_EXECUTABLE=#{which(python3)}
      -DCMAKE_INSTALL_PYTHONDIR=#{prefix/Language::Python.site_packages(python3)}
      -DADIOS2_BUILD_TESTING=OFF
      -DADIOS2_BUILD_EXAMPLES=OFF
      -DADIOS2_USE_EXTERNAL_DEPENDENCIES=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"test").install "examples/hello/bpWriter/bpWriter.cpp"
    (pkgshare/"test").install "examples/hello/bpWriter/bpWriter.py"
  end

  test do
    adios2_config_flags = Utils.safe_popen_read(bin/"adios2-config", "--cxx").chomp.split
    adios2_config_flags += %W[-L#{Formula["lz4"].opt_lib} -llz4]
    system "mpic++", "-std=c++17", pkgshare/"test/bpWriter.cpp", *adios2_config_flags
    system "./a.out"
    assert_path_exists testpath/"myVector_cpp.bp"

    system python3, "-c", "import adios2"
    system python3, pkgshare/"test/bpWriter.py"
    assert_path_exists testpath/"bpWriter-py.bp"
  end
end
