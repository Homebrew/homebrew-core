class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/refs/tags/v13.0.0.tar.gz"
  sha256 "4d6a91df5f347017496fe8d22c3dbb7c4b5d7289499d4eb4d53dd2c75bb454e1"
  license "MPL-2.0"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9034c0d9bc8ecbcd7afe7fa279dcdec883e9f52a24f292483bf6a11114c5516c"
    sha256 cellar: :any,                 arm64_sequoia: "1fd0ec25afe4eda5e17f9e514f4e6d6044ee8b99b61018c7f8e0172cb682b20c"
    sha256 cellar: :any,                 arm64_sonoma:  "bc65aebe2ed2107366d94834c39b7225c34f17f0d04b645b77078e339e56c534"
    sha256 cellar: :any,                 sonoma:        "e5f8963ee61f47880c836435595711ff1b8c6c4c0883dd3abb2ab11e2dfbd2b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41f66073e71b96789679ad2fb43f8fd4300d61590714489a3160fe3dc4735e1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39e3fc98d0da60fd9fe88a84be8f36f31f97c54f9ac638c6b9d8c024f97def8b"
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
