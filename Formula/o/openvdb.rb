class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/refs/tags/v12.0.0.tar.gz"
  sha256 "23ceb5b18a851f45af118f718a9dd3001efaee364e3f623c37ffbdad03b8905f"
  license "MPL-2.0"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "55a283638ce62c618c85cfee5ffc973c71e59a5c2f7895f1fc76e0d0ef5e420f"
    sha256 cellar: :any,                 arm64_sonoma:  "13df6e29f1587fd3d55da0ddbace3f9f3f73b1f11e9f3367f1cb09168f217b2d"
    sha256 cellar: :any,                 arm64_ventura: "4a150a24a7e922ad3a5c0e609e85c78b63146cc13c7b582299577dfd319dc60d"
    sha256 cellar: :any,                 sonoma:        "8aa0d7ef1b5194bcb8e542e69a02fcfa2f609afc9122ff14cf7c588151b704be"
    sha256 cellar: :any,                 ventura:       "bd1f67a30334dffeb1dee56dc6524e43c166dbdf49f5df7deba734551682292f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca1979daaa03fe9bc1819a0691074c781d29c132d5d02dd3e91c6458b34d9ee7"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  depends_on "boost"
  depends_on "c-blosc"
  depends_on "jemalloc"
  depends_on "openexr"
  depends_on "tbb"

  uses_from_macos "zlib"

  def install
    args = [
      "-DDISABLE_DEPENDENCY_VERSION_CHECKS=ON",
      "-DOPENVDB_BUILD_DOCS=ON",
      "-DUSE_NANOVDB=ON",
      "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}",
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-test_file" do
      url "https://artifacts.aswf.io/io/aswf/openvdb/models/cube.vdb/1.0.0/cube.vdb-1.0.0.zip"
      sha256 "05476e84e91c0214ad7593850e6e7c28f777aa4ff0a1d88d91168a7dd050f922"
    end

    testpath.install resource("homebrew-test_file")
    system bin/"vdb_print", "-m", "cube.vdb"
  end
end
