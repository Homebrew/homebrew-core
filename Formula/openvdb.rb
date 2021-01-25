class Openvdb < Formula
  desc "Sparse volume processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/v8.0.0.tar.gz"
  sha256 "04a28dc24a744f8ac8bbc5636a949628edb02b7c84db24ad795429c8c739a9ee"
  license "MPL-2.0"
  head "https://github.com/AcademySoftwareFoundation/openvdb.git"

  bottle do
    rebuild 1
    sha256 "aca9749f30518e713372752d61852505516171b6d3c99aa1b44dcc8ada9574c3" => :big_sur
    sha256 "97007153e3a295731c12e7c2bae5e60a8c4e98ec76651c5337023d7a524ad288" => :arm64_big_sur
    sha256 "f84f5645fe791485c6e41a59dfc602dc55fe84d233ac7c458646d41b8652ea52" => :catalina
    sha256 "fb01a2bbe0e6e2876815a8fdd70aee0b1868983cfeccb5482c291cd76a2596ab" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "c-blosc"
  depends_on "glfw"
  depends_on "ilmbase"
  depends_on "jemalloc"
  depends_on "openexr"
  depends_on "tbb"

  resource "test_file" do
    url "https://artifacts.aswf.io/io/aswf/openvdb/models/cube.vdb/1.0.0/cube.vdb-1.0.0.zip"
    sha256 "05476e84e91c0214ad7593850e6e7c28f777aa4ff0a1d88d91168a7dd050f922"
  end

  def install
    cmake_args = [
      "-DDISABLE_DEPENDENCY_VERSION_CHECKS=ON",
      "-DOPENVDB_BUILD_DOCS=ON",
    ]

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, *cmake_args
      system "make", "install"
    end
  end

  test do
    resource("test_file").stage testpath
    system "#{bin}/vdb_print", "-m", "cube.vdb"
  end
end
