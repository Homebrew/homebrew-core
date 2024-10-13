class Adios2 < Formula
  desc "Next generation of ADIOS developed in the Exascale Computing Program"
  homepage "https://adios2.readthedocs.io"
  url "https://github.com/ornladios/ADIOS2/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "ce776f3a451994f4979c6bd6d946917a749290a37b7433c0254759b02695ad85"
  license "Apache-2.0"
  revision 2
  head "https://github.com/ornladios/ADIOS2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "45eea725a5eeb5f9d065c31dbffea0821061147d36c546b02d20e68bb06fc699"
    sha256 arm64_sonoma:  "1b79ef697ee8019e54647b75ca7affa975964690c18fe4541c9cc6aa2869583e"
    sha256 arm64_ventura: "117b6e49f7c01a30d1803a20fc83eacaccf87062b29fe27d4696296939e304f3"
    sha256 sonoma:        "441101e346a040cebd96933dcc8f5ab6a132c593ef214f53e5299c7230d66ef9"
    sha256 ventura:       "380c9e3bf734c0a84ea23fa5ead042611038690ec0d51909611f7045288e17e7"
    sha256 x86_64_linux:  "725afb074ae040294d78d5d18a61cfe82fcb041b2206d1e119f446fc70c4a194"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "c-blosc"
  depends_on "gcc" # for gfortran
  depends_on "libfabric"
  depends_on "libpng"
  depends_on "libsodium"
  depends_on "mpi4py"
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "pugixml"
  depends_on "pybind11"
  depends_on "python@3.13"
  depends_on "sqlite"
  depends_on "yaml-cpp"
  depends_on "zeromq"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version == 1400
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

    (pkgshare/"test").install "examples/hello/bpWriter/bpWriter.cpp"
    (pkgshare/"test").install "examples/hello/bpWriter/bpWriter.py"
  end

  test do
    adios2_config_flags = Utils.safe_popen_read(bin/"adios2-config", "--cxx").chomp.split
    system "mpic++", pkgshare/"test/bpWriter.cpp", *adios2_config_flags
    system "./a.out"
    assert_predicate testpath/"myVector_cpp.bp", :exist?

    system python3, "-c", "import adios2"
    system python3, pkgshare/"test/bpWriter.py"
    assert_predicate testpath/"bpWriter-py.bp", :exist?
  end
end
