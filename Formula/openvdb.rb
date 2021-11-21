class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/v9.0.0.tar.gz"
  sha256 "ad3816e8f1931d1d6fdbddcec5a1acd30695d049dd10aa965096b2fb9972b468"
  license "MPL-2.0"
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "31063bc8947d87d94954752809d6ab0a0e84315ba147f9a653e6b6d11200f605"
    sha256 cellar: :any,                 arm64_big_sur:  "3b009e6f335c6dd6264c391ede13d7dcda7731851f8e6bb8d7f1395d1baa1338"
    sha256 cellar: :any,                 monterey:       "639c5b85b89dda8aeef75fa36e623f33fb9c5554e984adfe85b9a080728f3229"
    sha256 cellar: :any,                 big_sur:        "09b92c96f974aa12123a31b92c5cda3fec0678d6491c5e9895d7cdd8dbfdde50"
    sha256 cellar: :any,                 catalina:       "55ec23082cdec8e584dbacc3b566430a6d83f847b7fbaf58fcc817e05194b255"
    sha256 cellar: :any,                 mojave:         "2a82056566ede58322204b6881cd00600b210d8fd9a781fc46499a39d254830a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8c1520e74d9762f6aa607dae1a6d1a111e83808f3f7458c986b3e498fd3487d"
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
