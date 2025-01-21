class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/refs/tags/v12.0.0.tar.gz"
  sha256 "23ceb5b18a851f45af118f718a9dd3001efaee364e3f623c37ffbdad03b8905f"
  license "MPL-2.0"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6d0be9f773bea94bbed6cb06cad4f07e9526baf952a52926c1512d1bc2de64e9"
    sha256 cellar: :any,                 arm64_sonoma:  "8ca0840a1bfb0c776ae22885829f07d3b062be275fccfedf7d173791e457c11f"
    sha256 cellar: :any,                 arm64_ventura: "1b7930e40aba387978cdd8770dc7fc49815d56d14a8fd2c0483ca6bde96eb7c9"
    sha256 cellar: :any,                 sonoma:        "1b5e73284825dc8bb6b91b4e77de1dcec925857db4563c5c3bd34b4f84742d14"
    sha256 cellar: :any,                 ventura:       "b2d1739171e2860d0495f01b00ccc43dbd657bb034472ec5d670996a9aa0b820"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d859e0d01f913f27b444100afb2d0500a5648f58ab57d49e17b275de56d688a7"
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
