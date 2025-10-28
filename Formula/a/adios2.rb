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
    rebuild 1
    sha256 arm64_tahoe:   "544926ccf1bc80eb6a66cadfbcd50452ca3ac79159dc50dbddc5ccf68c78a64d"
    sha256 arm64_sequoia: "caf49db76e7ccd69679a897c33cae89ce8f6c3791b37e1e9e64f44b5ed1d3681"
    sha256 arm64_sonoma:  "f1d5cea886ed8cd5f968a842aca88fe6a45ecb2bce617aec503b52bed5da7ed9"
    sha256 arm64_ventura: "b1f76254ef5027a9f7b4975d78f978e08cb83fbabccf3f1c563b561ab894a27e"
    sha256 sonoma:        "14dcca08d1cc8ec5c34bbb9fd652e67614fa300dcc4cc1764279021ebe4eb1d0"
    sha256 ventura:       "7f46f4a0b3a3f652c98ad7ee92c0b7d12c32dd3ea35c990092f3194abc92940d"
    sha256 arm64_linux:   "4d6e615acfb2490c76cf4489959c40fbcda944ed33ae983157a2cac241de6e6f"
    sha256 x86_64_linux:  "9496dbfe1f33f6ee68f69692c979e083525425da1e3a8d220eab5d19f82e6a2b"
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
  depends_on "python@3.13"
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
    "python3.13"
  end

  def install
    ENV.llvm_clang if DevelopmentTools.clang_build_version == 1400

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
