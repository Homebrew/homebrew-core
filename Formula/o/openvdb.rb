class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/refs/tags/v12.1.0.tar.gz"
  sha256 "ebb9652ad1d67274e2c85e6736cced5f04e313c5671ae1ae548f174cc76e9e64"
  license "MPL-2.0"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "232ab82c1369b7af92fa07218eb27292d130f38b3c4870807f7f9454bb9b5824"
    sha256 cellar: :any,                 arm64_sonoma:  "ad9a1b698dc300df9892fe6a68e04d45cdaf39fa4bacc9513df325cef8c911fc"
    sha256 cellar: :any,                 arm64_ventura: "1fd94127d9139eb0c3830af8903f32a183384657c69ddaff24b59cb5c024f157"
    sha256 cellar: :any,                 sonoma:        "43c1f8555b53d5c1ed9211c727fdb4f46b018031cdeb62a6564ad78a36ba584f"
    sha256 cellar: :any,                 ventura:       "b51ff4add9efcafcb681dd9f12c8926f4daf6bea86ddda773c50f081861d9cf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "509056ab340fde04463ac04f1a178f827643a42d6813a584fb84e8039a67355a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20409c9a89ca12544d5438f8da2c5e78e08d43ff7160a3950c4926e09dc0b720"
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
