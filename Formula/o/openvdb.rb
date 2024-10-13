class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/refs/tags/v11.0.0.tar.gz"
  sha256 "6314ff1db057ea90050763e7b7d7ed86d8224fcd42a82cdbb9c515e001b96c74"
  license "MPL-2.0"
  revision 3
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "0d02cf53eccd0c359fcc880feb82f78d7eaf71cc54374d04c48a4a9ed14ef294"
    sha256 cellar: :any,                 arm64_sonoma:   "2e438c59d4d2cb1905c395e7aecf06ffd8d31e1ce364dbeede6cee719525a43f"
    sha256 cellar: :any,                 arm64_ventura:  "6331dfd7b9a92f4e5107a08d4a0d1df9b2a3c89b182e543d41c7fa86fb615b6b"
    sha256 cellar: :any,                 arm64_monterey: "2a43a1edffe1a2ad2a9b6bb44074d07682caff5ac5a3349c2fa72dcc5bf8caeb"
    sha256 cellar: :any,                 sonoma:         "076615ec23b41f4964411ca5ff4e5089d2ca6a45bc9ace90ae88054b5661c53f"
    sha256 cellar: :any,                 ventura:        "db0bba1bc1b53a719660e375db433144c7f4e8ff35f688ed83410d1d8fcd0813"
    sha256 cellar: :any,                 monterey:       "a0f29c79abd63667a4827b905c1491b6c7d68ded8b391279db5caaefb674e00e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47b4dba9cf936c2a44873e232b804c784222e1a80ee88a243933bea4c6acdeda"
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
