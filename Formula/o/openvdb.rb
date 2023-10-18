class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/v10.1.0.tar.gz"
  sha256 "2746236e29659a0d35ab90d832f7c7987dd2537587a1a2f9237d9c98afcd5817"
  license "MPL-2.0"
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "98522b652630410bda0a9f6eaca33263d6803fb4a58419191a2f45b9a2605a89"
    sha256 cellar: :any,                 arm64_ventura:  "79043ba12a17c4b3222804e29fc54c56851abecbcfaf5c50c298e1ab11f5ded9"
    sha256 cellar: :any,                 arm64_monterey: "3c6a7e5dcc92f52e0e12a2feefd8add826f4d3d8ac4144f0b6c6f1662053e8b4"
    sha256 cellar: :any,                 sonoma:         "6904eceafbbdbcc6dc78cbbfdcb9b8981b996073ffd1543897c01fedca36b3a6"
    sha256 cellar: :any,                 ventura:        "cf91e70857a62ecd6318807d9764f80ed42989c551476af5966b2da75bae76e6"
    sha256 cellar: :any,                 monterey:       "8b84c8556851500ae6dd430c6bd49c79974a2a6d6e0587fa309b74586cab42a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e723ee97e3f06e94b5dd285f9818ff53625111af943ec2642cb349ff5ba983c9"
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
