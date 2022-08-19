class Adios2 < Formula
  desc "Next generation of ADIOS developed in the Exascale Computing Program"
  homepage "https://adios2.readthedocs.io"
  url "https://github.com/ornladios/ADIOS2/archive/v2.8.3.tar.gz"
  sha256 "4906ab1899721c41dd918dddb039ba2848a1fb0cf84f3a563a1179b9d6ee0d9f"
  license "Apache-2.0"
  head "https://github.com/ornladios/ADIOS2.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "83553d5fcde79c8c434a045125bf2a4c14f0ec2f0474bdaed86e49a27f2e3468"
    sha256 arm64_big_sur:  "12e8d56600d45ee36e009f35db5c9c0e135c600711b5c6d0fe6f74793bfa1f82"
    sha256 monterey:       "103dd59b517acade622270c4616ed042100e601482be67b3646dfe3dccf2b36f"
    sha256 big_sur:        "8d0bb1de20d3b2a5c1515f001c4a8c60efbe8e7fe96b5638fede04d5b2907ca0"
    sha256 catalina:       "de572388459dff34987e156405a405858e634c21bcfe06ac67a289ca4d8366a6"
    sha256 x86_64_linux:   "d86f8fa004282b4f13a77b327ce2c17334b32168feef31c1f96b167d5155e42d"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "nlohmann-json" => :build
  depends_on "c-blosc"
  depends_on "libfabric"
  depends_on "libpng"
  depends_on "mpi4py"
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "pugixml"
  depends_on "pybind11"
  depends_on "python@3.10"
  depends_on "yaml-cpp"
  depends_on "zeromq"

  uses_from_macos "bzip2"

  def python3
    "python3.10"
  end

  def install
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
