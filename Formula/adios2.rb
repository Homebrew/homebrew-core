class Adios2 < Formula
  desc "Next generation of ADIOS developed in the Exascale Computing Program"
  homepage "https://adios2.readthedocs.io"
  url "https://github.com/ornladios/ADIOS2/archive/v2.9.0.tar.gz"
  sha256 "69f98ef58c818bb5410133e1891ac192653b0ec96eb9468590140f2552b6e5d1"
  license "Apache-2.0"
  head "https://github.com/ornladios/ADIOS2.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "e46326d9b93f258f510d31544553cc46a0e9ded8737d95e89af5425521bea981"
    sha256 arm64_monterey: "1e28a0fa8db8adabd7404943c2bf01fdb66534a3d328a44b449f0c593e7538fa"
    sha256 arm64_big_sur:  "9a950000b778dea1ea323a766f10c7add640972ebd41b40f7bd02f6e21b2b984"
    sha256 ventura:        "219066abe62b0a1f142b4da3cc89cc5dd64801ac152a20a5f6a923a3cdf75e92"
    sha256 monterey:       "d58ebb2d86f98d8729dc76a79f141bf18e4ee26de82d7ae92167202868ca49de"
    sha256 big_sur:        "6fb9906e4cd36ce26a8051ec388ed2ab865d02ada9d0a2cf7667e26bb51413b7"
    sha256 x86_64_linux:   "de9ce9ec642fe0ab16b83490d88f525fdc83fd21999c74b97cd46d25d31a4b11"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "c-blosc"
  depends_on "gcc" # for gfortran
  depends_on "libfabric"
  depends_on "libpng"
  depends_on "mpi4py"
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "pugixml"
  depends_on "pybind11"
  depends_on "python@3.11"
  depends_on "yaml-cpp"
  depends_on "zeromq"

  uses_from_macos "bzip2"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version == 1400
  end

  # clang: error: unable to execute command: Segmentation fault: 11
  # clang: error: clang frontend command failed due to signal (use -v to see invocation)
  # Apple clang version 14.0.0 (clang-1400.0.29.202)
  fails_with :clang if DevelopmentTools.clang_build_version == 1400

  def python3
    "python3.11"
  end

  def install
    ENV.llvm_clang if DevelopmentTools.clang_build_version == 1400

    # fix `include/adios2/common/ADIOSConfig.h` file audit failure
    inreplace "source/adios2/common/ADIOSConfig.h.in" do |s|
      s.gsub! ": @CMAKE_C_COMPILER@", ": #{ENV.cc}"
      s.gsub! ": @CMAKE_CXX_COMPILER@", ": #{ENV.cxx}"
    end

    args = %W[
      -DADIOS2_USE_Blosc=ON
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

    (pkgshare/"test").install "examples/hello/bpWriter/helloBPWriter.cpp"
    (pkgshare/"test").install "examples/hello/bpWriter/helloBPWriter.py"
  end

  test do
    adios2_config_flags = Utils.safe_popen_read(bin/"adios2-config", "--cxx").chomp.split
    system "mpic++", pkgshare/"test/helloBPWriter.cpp", *adios2_config_flags
    system "./a.out"
    assert_predicate testpath/"myVector_cpp.bp", :exist?

    system python3, "-c", "import adios2"
    system python3, pkgshare/"test/helloBPWriter.py"
    assert_predicate testpath/"npArray.bp", :exist?
  end
end
