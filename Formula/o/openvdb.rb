class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/refs/tags/v13.0.0.tar.gz"
  sha256 "4d6a91df5f347017496fe8d22c3dbb7c4b5d7289499d4eb4d53dd2c75bb454e1"
  license "MPL-2.0"
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b72fcc8c9a6af539ad9fbe8f77b33e5cdf536b3387da600b26e1fa3d482330d1"
    sha256 cellar: :any,                 arm64_sequoia: "3b47e9516fccd5f50d51eebd8bbbfee8561c958f413cbc3ed54bb477eddf643a"
    sha256 cellar: :any,                 arm64_sonoma:  "56fcc1277af3d4241f4f1b1516ecf2e0689513078f983f55aeaefae59c34daa4"
    sha256 cellar: :any,                 sonoma:        "729e1cd1d8866b2fe292f899fad16aa8924f645e6161cd29782c6e154a4b1e6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37916dd0822369844e0bbd29e1152a70006a9d27617a97c61f5b50082b8d68f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec203adc7cd404e6ad79dc6dddfba072f37140064dcaa6bf9aa98812dd775bea"
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
