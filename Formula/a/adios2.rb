class Adios2 < Formula
  desc "Next generation of ADIOS developed in the Exascale Computing Program"
  homepage "https://adios2.readthedocs.io"
  url "https://github.com/ornladios/ADIOS2/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "0a2bd745e3f39745f07587e4a5f92d72f12fa0e2be305e7957bdceda03735dbf"
  license "Apache-2.0"
  revision 1
  head "https://github.com/ornladios/ADIOS2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7fa82b45b998af8f55e80b9f2e4968269a15a948ac7d7ee214e1c8246776410e"
    sha256 arm64_sequoia: "ceb46caa64a19d4b356f55b97d4c1a72f241e50f9365b2da1e4d4c818a651ab4"
    sha256 arm64_sonoma:  "f4046eda0a50c11bc9783477eb87b83e20122eefcbc3089617766ad95853179a"
    sha256 sonoma:        "2178e5df4e6c3c7d10df31b173cc1112e7a3d7415ec80645f4f0e902902e75c3"
    sha256 arm64_linux:   "6a6b5560c0052880a8c6d7325316d3a528a02f826d9886d4e097cd5d03767488"
    sha256 x86_64_linux:  "ebe1f099875e539e250a301128b232c664e143d28439babfbf193d7a948f62d5"
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
  depends_on "openssl@3"
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

  # Upstream PR: https://github.com/ornladios/ADIOS2/pull/4791
  patch do
    url "https://github.com/ornladios/ADIOS2/commit/1dcffdf15a90282549ce679e96ac59f35e93acde.patch?full_index=1"
    sha256 "1133316f038abed99824d00584b70454122083cf0e2717a1322511b91a14c4dd"
  end

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
