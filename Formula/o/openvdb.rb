class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/refs/tags/v12.1.0.tar.gz"
  sha256 "ebb9652ad1d67274e2c85e6736cced5f04e313c5671ae1ae548f174cc76e9e64"
  license "MPL-2.0"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a3ddd7eeea8feb94dcb164a5e63053bc4002af989223029e954cdefa0d1637e"
    sha256 cellar: :any,                 arm64_sequoia: "f7b1ae1b4714ee2a3054ed21f7614fbf558806b8ac712036f859da671804493f"
    sha256 cellar: :any,                 arm64_sonoma:  "b12361d329988e7e23f9d09f74869171caff33520419ec0a9333d076c8b6af4b"
    sha256 cellar: :any,                 arm64_ventura: "6147b904295c5d09e05b80d3e3d345c9a3d4b085562e0e3c8b97339323c43ed9"
    sha256 cellar: :any,                 sonoma:        "23505396f7baaacc017de11e2d2864b7ed646e72a9470bc9d364dff35995b81b"
    sha256 cellar: :any,                 ventura:       "1a9228f339b3294a3c141c7018fd680bd6176549bdc1fd6fb287cac384c1def6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee4ea667d3e8f0439641e82f26c2685f29bb3571985855a3c758e2166244fee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef171922b7fc92150b734b959ee16e99a3fd3a0f0deffa5d507d65af55e02d03"
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
