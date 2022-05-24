class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/v9.0.0.tar.gz"
  sha256 "ad3816e8f1931d1d6fdbddcec5a1acd30695d049dd10aa965096b2fb9972b468"
  license "MPL-2.0"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "29ca05b8a12fc73fc8077fd7036a40a5bd2833a08b691e34f06e0906f1327bd8"
    sha256 cellar: :any,                 arm64_big_sur:  "1be18c439e2f597acb6ab7b6c5015e8c0bde503433edfc14b7a95cdea0fef0cb"
    sha256 cellar: :any,                 monterey:       "e5e41fcadf23b328b30703d4d952dcc4ad2cfb6a29eeb5e4d0455e6964717c6b"
    sha256 cellar: :any,                 big_sur:        "4e70a60cafb9635500c69863519d4b084a3dafbb3bcec6bcf17d89c9181e295c"
    sha256 cellar: :any,                 catalina:       "e8c0ab754b18fd72603c9d48ce2b985a70096f419f35266c2e3b3f5fd11ac8e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffd1aa828c4e1d1e20eada6d5d6276347722378e643013cc8630362cf646a262"
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
