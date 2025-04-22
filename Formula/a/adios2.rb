class Adios2 < Formula
  desc "Next generation of ADIOS developed in the Exascale Computing Program"
  homepage "https://adios2.readthedocs.io"
  url "https://github.com/ornladios/ADIOS2/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "14cf0bcd94772194bce0f2c0e74dba187965d1cffd12d45f801c32929158579e"
  license "Apache-2.0"
  head "https://github.com/ornladios/ADIOS2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "502983bb973c584e61ea4325857019308d37ed7876149ca8b692e462a7350e96"
    sha256 arm64_sonoma:  "f85ec0a3210c79e1730d3f7f71c88de5f75fe6a4a9ca9449935ebd2e97145044"
    sha256 arm64_ventura: "e75a203fbaa7987772e61ba24b66419ae5a5e1b69d8f29524d431330accb9caf"
    sha256 sonoma:        "5caafa5a27988407eb69e25b2a1f03a61d584af7d152efbc90b2f197586a6f2e"
    sha256 ventura:       "f22fdaa080f998c8ecd24b826c148ad60bc587a7acc3f0c49171e8d61ddcb7a3"
    sha256 arm64_linux:   "411a036e81100ec289c17b95296b8665dddc42b41ba01660bdd1dab70ae1e723"
    sha256 x86_64_linux:  "6eccf49dc0677c2e62f0a5fdc69872e35552137b6339ebccca057795480be4bf"
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
    assert_path_exists testpath/"myVector_cpp.bp"

    system python3, "-c", "import adios2"
    system python3, pkgshare/"test/bpWriter.py"
    assert_path_exists testpath/"bpWriter-py.bp"
  end
end
