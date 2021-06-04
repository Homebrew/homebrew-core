class Openvdb < Formula
  desc "Sparse volume processing toolkit"
  homepage "https://www.openvdb.org/"
  # Check whether this can be switched to `openexr`, `imath`, and `tbb` at version bump
  # https://github.com/AcademySoftwareFoundation/openvdb/issues/1034
  # https://github.com/AcademySoftwareFoundation/openvdb/issues/932
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/v8.0.1.tar.gz"
  sha256 "a6845da7c604d2c72e4141c898930ac8a2375521e535f696c2cd92bebbe43c4f"
  license "MPL-2.0"
  revision 2
  head "https://github.com/AcademySoftwareFoundation/openvdb.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ed36d4355a32b8747fa97a9daffad31291a17738cab0d8b238b1ff3b2e651d3c"
    sha256 cellar: :any, big_sur:       "e40f84714feb845bcc67b693ba709aa23e5fd2a12ae77a4e7e39bf5a16ca8329"
    sha256 cellar: :any, catalina:      "2a9d6a3246e04b72f5a39e19a4be80351b50ec1161032a2ac4d9ab4898839967"
    sha256 cellar: :any, mojave:        "68f97f2661f7042b36f208437061cb8a9c0d4c3b2c39ecc0a82351a5a59e231e"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "c-blosc"
  depends_on "glfw"
  depends_on "ilmbase"
  depends_on "jemalloc"
  depends_on "openexr@2"
  depends_on "tbb@2020"

  resource "test_file" do
    url "https://artifacts.aswf.io/io/aswf/openvdb/models/cube.vdb/1.0.0/cube.vdb-1.0.0.zip"
    sha256 "05476e84e91c0214ad7593850e6e7c28f777aa4ff0a1d88d91168a7dd050f922"
  end

  def install
    cmake_args = [
      "-DDISABLE_DEPENDENCY_VERSION_CHECKS=ON",
      "-DOPENVDB_BUILD_DOCS=ON",
      "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}",
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
