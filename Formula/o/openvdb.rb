class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/v10.0.1.tar.gz"
  sha256 "887a3391fbd96b20c77914f4fb3ab4b33d26e5fc479aa036d395def5523c622f"
  license "MPL-2.0"
  revision 2
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "01190f5c5edd5765b21b724ef1f1e0678bf18a508e554738ba33c0b2de888601"
    sha256 cellar: :any,                 arm64_monterey: "64987424c7b0f0576f7fa0b954cfabe80f160da5000ec91846ed66939dba2387"
    sha256 cellar: :any,                 arm64_big_sur:  "f2dbea98ce2c7e3e0bc423a91904316f040469e22bb364035e05d6ea1a3a1931"
    sha256 cellar: :any,                 ventura:        "490896324bacfcfb1a4b8111f61529460e1d1056e803303502d02564db2ac84a"
    sha256 cellar: :any,                 monterey:       "76fe6dc5b8ffe51b23737a6c01e45c369756d5d1a9304743d98d31b5cf0e6802"
    sha256 cellar: :any,                 big_sur:        "4bf62e18ae6239180961d62e6d0e7e9a81908e2ccba327c7d43ec697df809aee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "070963ab134cff2fdc139871735a1db62a36e830cc432ff9efd087721827b39f"
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
