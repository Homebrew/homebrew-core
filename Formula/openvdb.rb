class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/v10.0.1.tar.gz"
  sha256 "887a3391fbd96b20c77914f4fb3ab4b33d26e5fc479aa036d395def5523c622f"
  license "MPL-2.0"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5472be4da9c5a690cce44a39f0024a5ae9201da16dcc6438f883ffea4284de6c"
    sha256 cellar: :any,                 arm64_monterey: "f5b13e4ae82ce1ed42ced417cf01a168ee3d0a27a7fe9c01add81022fa60368c"
    sha256 cellar: :any,                 arm64_big_sur:  "037bf5625ebe7cd3a1be4081d61431c3749ee6ecf488d73adfa49a7b7c9970c8"
    sha256 cellar: :any,                 ventura:        "74451d1fbe49b1f455790419e3e59b72177fd0146efe582b0c945a202db20781"
    sha256 cellar: :any,                 monterey:       "6d2c8e036d72302449e70a456085562421885b98e96466d00e8272762c0c8ce5"
    sha256 cellar: :any,                 big_sur:        "272179ed919a3111340891293cb11f39817d656a3a42ba89cb7c79cee87271a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1462c86b3cc54bc87e6551c565580feafa7111bd0e927170be74dd0d66ee1689"
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
