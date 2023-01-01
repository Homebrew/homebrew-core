class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/v10.0.1.tar.gz"
  sha256 "887a3391fbd96b20c77914f4fb3ab4b33d26e5fc479aa036d395def5523c622f"
  license "MPL-2.0"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9109634e9017ae798abb76b755ad3f2fbafa8f060a7380b2377e0f72136b3653"
    sha256 cellar: :any,                 arm64_monterey: "0a5934e30e53fc3a1c0d396c6ae7b1f51a8cfa1c8d7c8f3a27828aef4ca9420b"
    sha256 cellar: :any,                 arm64_big_sur:  "8044543b18410fe7f02f5444625e1775e241ad7c2418b29d3cc6e5fa8527e0e7"
    sha256 cellar: :any,                 ventura:        "2902fa32eeaced9f82f287606d1320a0f00a733b03100657271266e91946c9a7"
    sha256 cellar: :any,                 monterey:       "9c15532e528f940abf58f41f02588e8d2a15a130defe65f626db904f7bb3b282"
    sha256 cellar: :any,                 big_sur:        "cd16025c27d55691be1e45d2308e9ca5abe936fa4850af6ccf214c4e3442f16e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb7ba0419a7853e4cb9824cdfb4822ee9896c06ac2709592e753202dbd4bb38c"
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
