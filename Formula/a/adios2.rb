class Adios2 < Formula
  desc "Next generation of ADIOS developed in the Exascale Computing Program"
  homepage "https://adios2.readthedocs.io"
  url "https://github.com/ornladios/ADIOS2/archive/refs/tags/v2.12.1.tar.gz"
  sha256 "71edd8f721448311852122fca8d83ae497b43846e5bfcdfd275dc06bb7f3d0c5"
  license "Apache-2.0"
  head "https://github.com/ornladios/ADIOS2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "264adbac2b0515a18279cc09c2564f506d124b4972ba4c2ece22414c9d6d3577"
    sha256 cellar: :any,                 arm64_sequoia: "a40d806dc776c0a71daf37be4489c58d4515b6f78f6e7104f1dbbf3a9093070e"
    sha256 cellar: :any,                 arm64_sonoma:  "970a0cf1cbf813bb8e24674b92ea06cdc9403df71d0edd97d0156067fec93d8a"
    sha256 cellar: :any,                 sonoma:        "d39e90c524ab681ab22c2c67a832d2649d4d845874a935c8ca21d080a67bf250"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa59f68ddc63cd454ee9187efa912e39f2c1dc749ac1fa8e103dc3e625d2166f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbb723202b8917802c16657a1233a27c257178dbd5bbbc71b6067f498c4d7d5e"
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
  depends_on "nanobind"
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "openssl@3"
  depends_on "pugixml"
  depends_on "python@3.14"
  depends_on "sqlite"
  depends_on "yaml-cpp"
  depends_on "zeromq"

  uses_from_macos "bzip2"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version == 1400
    depends_on "lz4"
    depends_on "zstd"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # clang: error: unable to execute command: Segmentation fault: 11
  # clang: error: clang frontend command failed due to signal (use -v to see invocation)
  # Apple clang version 14.0.0 (clang-1400.0.29.202)
  fails_with :clang if DevelopmentTools.clang_build_version == 1400

  def python3
    "python3.14"
  end

  def install
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
      -DADIOS2_USE_EXTERNAL_PERFSTUBS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Remove standalone helper script that upstream installs as a non-executable.
    rm bin/"bpcmp.py"

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
