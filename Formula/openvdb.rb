class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/v9.1.0.tar.gz"
  sha256 "914ee417b4607c75c95b53bc73a0599de4157c7d6a32e849e80f24e40fb64181"
  license "MPL-2.0"
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "61a904eba18253e42fa51b5e393babc7a4e976e9d860e0f3f771c5e86815253c"
    sha256 cellar: :any,                 arm64_big_sur:  "05b7045e388b78aaec42c94e2e0862c1dc7a9d3b63b71f01e675ffc995e585ff"
    sha256 cellar: :any,                 monterey:       "1aa3c07aef9e25ce0cd8c3f0ff76bd2d12edaf98e7e980e879e59639b7cd4083"
    sha256 cellar: :any,                 big_sur:        "bf608f904cc2b410f505be89fbab92df36947a56fe6f17565366b43a309f6a73"
    sha256 cellar: :any,                 catalina:       "3cb43e10bdcd36d4fe3a6e8de7175d9e3cb3665c62ae941bc28f83b63a496ac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b968e45f86b4063d52aeee9d3d05ef9ec7bb6091495305d9fd13c258cd4f80b"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "c-blosc"
  depends_on "jemalloc"
  depends_on "openexr"
  depends_on "tbb"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  resource "test_file" do
    url "https://artifacts.aswf.io/io/aswf/openvdb/models/cube.vdb/1.0.0/cube.vdb-1.0.0.zip"
    sha256 "05476e84e91c0214ad7593850e6e7c28f777aa4ff0a1d88d91168a7dd050f922"
  end

  def install
    cmake_args = [
      "-DDISABLE_DEPENDENCY_VERSION_CHECKS=ON",
      "-DOPENVDB_BUILD_DOCS=ON",
      "-DUSE_NANOVDB=ON",
      "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}",
    ]

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, *cmake_args
      system "make", "install"
    end
  end

  test do
    resource("test_file").stage testpath
    system bin/"vdb_print", "-m", "cube.vdb"
  end
end
