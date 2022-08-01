class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/v9.1.0.tar.gz"
  sha256 "914ee417b4607c75c95b53bc73a0599de4157c7d6a32e849e80f24e40fb64181"
  license "MPL-2.0"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 cellar: :any,                 arm64_monterey: "335cfb69a9e3b591eed64131c41822f00058a021b097359ab8f02100b5a79317"
    sha256 cellar: :any,                 arm64_big_sur:  "2a8919f3442922f0249c66006d0008416499bb3beba78e75100a507db3809c0d"
    sha256 cellar: :any,                 monterey:       "cec4679ecf428581b69615253c728de62678e3339b5d8e7fa8083ee508c40d57"
    sha256 cellar: :any,                 big_sur:        "6cc379c5eee390df9758d01d1ef4f9ceeed21427d76a5b1424b0446f797df437"
    sha256 cellar: :any,                 catalina:       "c1e459e1d5d7c510420030dbaee505d0db0444494cbd95a6eef9c207515a7a06"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "c-blosc"
  depends_on "jemalloc"
  depends_on "openexr"
  depends_on "tbb"

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
