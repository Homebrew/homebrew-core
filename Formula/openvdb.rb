class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/v9.0.0.tar.gz"
  sha256 "ad3816e8f1931d1d6fdbddcec5a1acd30695d049dd10aa965096b2fb9972b468"
  license "MPL-2.0"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4efeba9379d21856de78e1502bfbb0e9914fb9f770b10c8ca353c763c5425dbd"
    sha256 cellar: :any,                 arm64_big_sur:  "4acd2ab4377e2fc5a75ed9c778e96061d35e4bb4428d14e4d7ebfd669df305b7"
    sha256 cellar: :any,                 monterey:       "418a7fccce828311fa23674d50ed5d24422ba253bb7aac2adc37545e8046606a"
    sha256 cellar: :any,                 big_sur:        "3d094143c12d6b8708d2df2823c6713e7e773d7ce871c3c2443dc1f3278ec77e"
    sha256 cellar: :any,                 catalina:       "73d9710a66677ce795271bb0f737ae59ab01550729e4b848440c570566177b62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaa6699c14759acee35d1ea14a7c081924a0850ac99cdfc779fa234ea98238f7"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "c-blosc"
  depends_on "jemalloc"
  depends_on "openexr"
  depends_on "tbb"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  resource "test_file" do
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
    resource("test_file").stage testpath
    system bin/"vdb_print", "-m", "cube.vdb"
  end
end
