class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/refs/tags/v13.0.0.tar.gz"
  sha256 "4d6a91df5f347017496fe8d22c3dbb7c4b5d7289499d4eb4d53dd2c75bb454e1"
  license "MPL-2.0"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "1293e06e4fc2e23da53c13d0ff875e61484d85c6d734a8df1817ac7522b368e9"
    sha256 cellar: :any,                 arm64_sequoia: "d92c0b472575bdd80490eeb159c01abc9bffcb0c282173067622a13b25cf1273"
    sha256 cellar: :any,                 arm64_sonoma:  "40b91eee6ca47d33a5d0568ef6f98ae1984cbe312abbbffa6acdec3fc9641afa"
    sha256 cellar: :any,                 sonoma:        "a7edb4bef446e3b92421e3a66a282b6c0c0fa0440e79e8c8567c00b59f84bbd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12ab28558982809431b5d9eb176a8f8e133b59698e40db52bb0fb8682a66b20b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "595a235b9cbabb8f5dd8797681e9bde7d00662a91835b21ad7a961f1ee9fa09b"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  depends_on "boost"
  depends_on "c-blosc"
  depends_on "jemalloc"
  depends_on "openexr"
  depends_on "tbb"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
