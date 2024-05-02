class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/refs/tags/v11.0.0.tar.gz"
  sha256 "6314ff1db057ea90050763e7b7d7ed86d8224fcd42a82cdbb9c515e001b96c74"
  license "MPL-2.0"
  revision 2
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ce4f53ab5f361bb8437adbc031525cdd20ceeee3388c93548aa9f8ea03f46f9e"
    sha256 cellar: :any,                 arm64_ventura:  "707877f486f47662c3e11cb1f291caf9a38ca8617927541c520478ca72213eb7"
    sha256 cellar: :any,                 arm64_monterey: "8e497d4bbcb116725815d158cb6daffda9048b72eb3abb55b336003ee450deeb"
    sha256 cellar: :any,                 sonoma:         "97afd3d0075cf399e69d35487b73edfd3bcf0310dc767873b955257b206d86b1"
    sha256 cellar: :any,                 ventura:        "5433d45a078a7a9d9179416a06a0898499a57729675e0e8dfc10fa91289762bb"
    sha256 cellar: :any,                 monterey:       "af4a1e95371e66ddc38e61317bcd3928deed3c30b6e29b04ece894565a1f0792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b29fab6204500087203be4074253efbfc70c532761bc7fcee9281073f9722829"
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
