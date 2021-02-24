class Openvdb < Formula
  desc "Sparse volume processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/v8.0.1.tar.gz"
  sha256 "a6845da7c604d2c72e4141c898930ac8a2375521e535f696c2cd92bebbe43c4f"
  license "MPL-2.0"
  head "https://github.com/AcademySoftwareFoundation/openvdb.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9cb0c66ec3ad5baa45c67f8dada344f9ea146f77e077addefbea16706764980a"
    sha256 cellar: :any, big_sur:       "bd06f00067f72d29c1db2d4dc5b89b4478f03b2706f0643ac2b7d7014339c0c3"
    sha256 cellar: :any, catalina:      "6a6d9b59e6e0a83d1067183a239fb01cd6fccdc18951e50bca8221a7b14934de"
    sha256 cellar: :any, mojave:        "942d34f3346db67246bcb9d9ad642c6f328645425fced48f68e885277d3c09be"
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
