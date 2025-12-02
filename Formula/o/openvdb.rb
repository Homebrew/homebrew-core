class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/refs/tags/v13.0.0.tar.gz"
  sha256 "4d6a91df5f347017496fe8d22c3dbb7c4b5d7289499d4eb4d53dd2c75bb454e1"
  license "MPL-2.0"
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "445ead0c4325371ced66df0d99da1f8424dfb49c4347709f14fae008f1dd5f0e"
    sha256 cellar: :any,                 arm64_sequoia: "420be15429bb1e5466dd1ed118089d2bda393112bb0e6cb185cf7718e26447bd"
    sha256 cellar: :any,                 arm64_sonoma:  "9cc0cd25b0f828f31b22fdf35678f1103d236afb1e0b3085567a40d5b9412582"
    sha256 cellar: :any,                 sonoma:        "7dce3911efbd25d010ea5d421456aeea2e434ab02680a6058aae9e3d843a1f31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbfa41538b6984822cd664d9b806a6a080fc0fa73d2446086365d556c182b06e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "777fc2c5878dac4d41c5a862a5df09605afa41bf733685b2ccdccd7d77ac7817"
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
