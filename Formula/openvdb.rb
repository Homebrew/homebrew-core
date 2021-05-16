class Openvdb < Formula
  desc "Sparse volume processing toolkit"
  homepage "https://www.openvdb.org/"
  # Check whether this can be switched to `openexr` and `imath` at version bump
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/v8.0.1.tar.gz"
  sha256 "a6845da7c604d2c72e4141c898930ac8a2375521e535f696c2cd92bebbe43c4f"
  license "MPL-2.0"
  revision 2
  head "https://github.com/AcademySoftwareFoundation/openvdb.git"

  bottle do
    sha256 arm64_big_sur: "c44a27f955af5aefb5dcc261f6510c7ae0481bbb53bf0f49ff0a0aed8a5fed6c"
    sha256 big_sur:       "9434d3db9e7bf017b661e9e289a653f99365f08c4f784536a20ec6f1fdca7274"
    sha256 catalina:      "6281c2b480d0ddb3dd0ffb1aec1d3923902f6dd2e9df5c0ea17f4f233a85c7a6"
    sha256 mojave:        "e90012d44ce759ed35d22e65affe874ece89624d2a825a3a101328ce480851bc"
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
