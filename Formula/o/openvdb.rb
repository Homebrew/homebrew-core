class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/refs/tags/v12.0.1.tar.gz"
  sha256 "a3c8724ecadabaf558b6e1bd6f1d695e93b82a7cfdf144b8551e5253340ddce0"
  license "MPL-2.0"
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b74d169a03f790fca5cd4108d9f6638af3542a93e571e1494da2a1f7f327cd92"
    sha256 cellar: :any,                 arm64_sonoma:  "a97fb8920961c74f730c83a5c1fbfdbcbd0cf26c155128dd80f89cdf09e9614f"
    sha256 cellar: :any,                 arm64_ventura: "a22516b823cfe6540e2fb9028da50f3b467978568df22e504ed2ece36e637ee5"
    sha256 cellar: :any,                 sonoma:        "b60fad4216111651a1219619e1515e0498351f3c5812bcbabffc356535b7e903"
    sha256 cellar: :any,                 ventura:       "7518c608ed08cbf7253186ab42349552db3f14831e86a56ae6c5f94e8e0ffc34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffffcbc256cab47663315930865dd713b3de54cb39d91299b294616782a3e280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d7f869b282486a9c0d192131c337179d65fce3acc733b86c3733ff994ab489c"
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
