class Adios2 < Formula
  desc "Next generation of ADIOS developed in the Exascale Computing Program"
  homepage "https://adios2.readthedocs.io"
  url "https://github.com/ornladios/ADIOS2/archive/v2.6.0.tar.gz"
  sha256 "45b41889065f8b840725928db092848b8a8b8d1bfae1b92e72f8868d1c76216c"
  license "Apache-2.0"
  revision 2
  head "https://github.com/ornladios/ADIOS2.git", branch: "master"

  bottle do
    sha256 "549ce3b6de7131b44c4b8403685cf8addc18d22439d437071474c067309b57e7" => :catalina
    sha256 "c90a3bf6d0176b0bd19aafbca19b20a0347d71f5176f38840bb10c4683d2b3e3" => :mojave
    sha256 "52fb482680fc9d96709dba546c045e5f1cf4526a9165d8abebde862d4bac3256" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "c-blosc"
  depends_on "libfabric"
  depends_on "libpng"
  depends_on "mpi4py"
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "python@3.8"
  depends_on "zeromq"
  uses_from_macos "bzip2"

  # macOS 10.13 configuration-time issue detecting float types
  # reference: https://github.com/ornladios/ADIOS2/pull/2305
  # can be removed after v2.6.0
  patch do
    url "https://github.com/ornladios/ADIOS2/commit/e92f052bc26816b30d3399343a005ea82b88afaf.diff?full_index=1"
    sha256 "cd03664974906f84e592944e9ee9e5471f84d52a156815da49ed9a38943b6056"
  end

  def install
    # fix `include/adios2/common/ADIOSConfig.h` file audit failure
    inreplace "source/adios2/common/ADIOSConfig.h.in" do |s|
      s.gsub! ": @CMAKE_C_COMPILER@", ": /usr/bin/clang"
      s.gsub! ": @CMAKE_CXX_COMPILER@", ": /usr/bin/clang++"
    end

    args = std_cmake_args + %W[
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
      -DPYTHON_EXECUTABLE=#{Formula["python@3.8"].opt_bin}/python3
      -DADIOS2_BUILD_TESTING=OFF
      -DADIOS2_BUILD_EXAMPLES=OFF
    ]
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      rm_rf Dir[prefix/"bin/bp4dbg"] # https://github.com/ornladios/ADIOS2/pull/1846
    end

    (pkgshare/"test").install "examples/hello/bpWriter/helloBPWriter.cpp"
    (pkgshare/"test").install "examples/hello/bpWriter/helloBPWriter.py"
  end

  test do
    adios2_config_flags = `adios2-config --cxx`.chomp.split
    system "mpic++",
           (pkgshare/"test/helloBPWriter.cpp"),
           *adios2_config_flags
    system "./a.out"
    assert_predicate testpath/"myVector_cpp.bp", :exist?

    system Formula["python@3.8"].opt_bin/"python3", "-c", "import adios2"
    system Formula["python@3.8"].opt_bin/"python3", (pkgshare/"test/helloBPWriter.py")
    assert_predicate testpath/"npArray.bp", :exist?
  end
end
