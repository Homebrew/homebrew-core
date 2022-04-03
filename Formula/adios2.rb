class Adios2 < Formula
  desc "Next generation of ADIOS developed in the Exascale Computing Program"
  homepage "https://adios2.readthedocs.io"
  url "https://github.com/ornladios/ADIOS2/archive/v2.8.0.tar.gz"
  sha256 "5af3d950e616989133955c2430bd09bcf6bad3a04cf62317b401eaf6e7c2d479"
  license "Apache-2.0"
  head "https://github.com/ornladios/ADIOS2.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "b6148919b1fbb3c8f5a1eeb67894b5e92d0d0c085257a1265ec81e9459e77cf8"
    sha256 arm64_big_sur:  "8d79ac6b2438a56c9256a098c7a1c15523d2e96e6dbaefbe010022e4d3719b25"
    sha256 monterey:       "37026a1bd30eaee38ae68091889c5edfbe0a4ad3662d749f6649b168a6677755"
    sha256 big_sur:        "e7af11bf80663b8f7ba7fa38198a7d967c79a944b57c18a4da06e83d2735cb2f"
    sha256 catalina:       "c0fbca5a05eb7f3e7649bb021a46069a6ef2fff44ce805cbbc6d7d868ce56bea"
    sha256 x86_64_linux:   "3660d2feeebdab716d48a5270770372c295c5abb64de24d4b8e7287b9400916f"
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
