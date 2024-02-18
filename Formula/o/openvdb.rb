class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/refs/tags/v11.0.0.tar.gz"
  sha256 "6314ff1db057ea90050763e7b7d7ed86d8224fcd42a82cdbb9c515e001b96c74"
  license "MPL-2.0"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "00c634e725ff475c88a6cabf7cde54f3426452aec1b3eeb4d359f24df8b7f09c"
    sha256 cellar: :any,                 arm64_ventura:  "a62fa759e991301831b6d7f3480c40fd9606b5275c33dddc90d6362a2af84a2f"
    sha256 cellar: :any,                 arm64_monterey: "44b14de00a89fda65a920b22535a9c966b658c709e0b89509f52994f98609f7e"
    sha256 cellar: :any,                 sonoma:         "2ceebb8537306b3b1328258a2c81d71d1531e28d3dd78243c90ce8adb2ade179"
    sha256 cellar: :any,                 ventura:        "2cfb276a2c30762cb39ea959910a49226088c5e0b11925f49b5ae6c067743f1e"
    sha256 cellar: :any,                 monterey:       "369ba5343dac9f433ec5a7080bde1696a986574335c619ee2263672b65d3a630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d51b8cbf3e6310c6edabfec234dfe51526150e8e892fcfda2e12081a16605d80"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "c-blosc"
  depends_on "jemalloc"
  depends_on "openexr"
  depends_on "tbb"

  fails_with gcc: "5"

  resource "homebrew-test_file" do
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
    resource("homebrew-test_file").stage testpath
    system bin/"vdb_print", "-m", "cube.vdb"
  end
end
