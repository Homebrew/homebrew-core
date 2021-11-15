class Adios2 < Formula
  desc "Next generation of ADIOS developed in the Exascale Computing Program"
  homepage "https://adios2.readthedocs.io"
  url "https://github.com/ornladios/ADIOS2/archive/v2.7.1.tar.gz"
  sha256 "c8e237fd51f49d8a62a0660db12b72ea5067512aa7970f3fcf80b70e3f87ca3e"
  license "Apache-2.0"
  revision 1
  head "https://github.com/ornladios/ADIOS2.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "b6b6dbcbe7d3d1ad478d47b4004d9ac932707a2503f810439680672a87b89e2b"
    sha256 monterey:      "43469ded9b6f8253cef8e12fcc64138f406f70c71705e3d7b59b8f001b357900"
    sha256 big_sur:       "7d1abe16be0173d2c1e645c51641b59fea8983c140c5caef132016d4e1416568"
    sha256 catalina:      "6826ba1d0cf70bd775a97a152fa2423b0091dfb196500d5a1eef0884f6e9d2f8"
    sha256 mojave:        "ec0da5f5869f0473b3c7b906cb4ea86d7673f4ff3bb479d6cf88621beb990507"
    sha256 x86_64_linux:  "1ff13a5c092bdbecb0ae8e3b5ec7a0b7910550c22ac7376c41ec92708138b67e"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "c-blosc"
  depends_on "libfabric"
  depends_on "libpng"
  depends_on "mpi4py"
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "python@3.9"
  depends_on "zeromq"
  uses_from_macos "bzip2"

  def install
    # fix `include/adios2/common/ADIOSConfig.h` file audit failure
    inreplace "source/adios2/common/ADIOSConfig.h.in" do |s|
      s.gsub! ": @CMAKE_C_COMPILER@", ": #{ENV.cc}"
      s.gsub! ": @CMAKE_CXX_COMPILER@", ": #{ENV.cxx}"
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
      -DPython_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3
      -DCMAKE_INSTALL_PYTHONDIR=#{prefix/Language::Python.site_packages("python3")}
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

    system Formula["python@3.9"].opt_bin/"python3", "-c", "import adios2"
    system Formula["python@3.9"].opt_bin/"python3", (pkgshare/"test/helloBPWriter.py")
    assert_predicate testpath/"npArray.bp", :exist?
  end
end
