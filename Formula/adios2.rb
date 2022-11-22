class Adios2 < Formula
  desc "Next generation of ADIOS developed in the Exascale Computing Program"
  homepage "https://adios2.readthedocs.io"
  url "https://github.com/ornladios/ADIOS2/archive/v2.8.3.tar.gz"
  sha256 "4906ab1899721c41dd918dddb039ba2848a1fb0cf84f3a563a1179b9d6ee0d9f"
  license "Apache-2.0"
  revision 1
  head "https://github.com/ornladios/ADIOS2.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "dd6c2120b4b480f41ed467eb288b7df6ad5c87a12fde5cb4d5b02c90098f2441"
    sha256 arm64_big_sur:  "b4c89ff59b0ed1b9c0bfe323baa1125955d07bfe64fa7dfdaf7a53d077a0b22e"
    sha256 ventura:        "3240624d9596ea6f0dc5dfcae7a2b9fff81e5bd170ead385ec25522be3434254"
    sha256 monterey:       "5240e042cad078b840fe117bdd706f47786cbf3cc0db1eb91f9d26237de28d24"
    sha256 big_sur:        "1bef95f698fa1d53a16c66fcfe0b60543b5257554f9fee86041f415a3b73a8f1"
    sha256 catalina:       "dfb2ed4262187889d97bd41581c4642399d6e0544c9def52542d75e4e937e8ca"
    sha256 x86_64_linux:   "aca7267638aaf558da97c828901c791a6698fe4c789882ac97b4f8860c53be99"
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

    # Fix for newer CMake
    # https://github.com/ornladios/ADIOS2/issues/3309
    inreplace "CMakeLists.txt", "cmake_minimum_required(VERSION 3.12)",
                                "cmake_minimum_required(VERSION 3.12...3.23)"

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
