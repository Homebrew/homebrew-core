class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/refs/tags/v12.0.1.tar.gz"
  sha256 "a3c8724ecadabaf558b6e1bd6f1d695e93b82a7cfdf144b8551e5253340ddce0"
  license "MPL-2.0"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e5e2388088cb975d19b0664d6ef76daa9c6e5fb580a51edd5b2eb7e25baeb934"
    sha256 cellar: :any,                 arm64_sonoma:  "396a754a3814699ae6e6e7685b40d355200be6317d417f792c66fd65f739d107"
    sha256 cellar: :any,                 arm64_ventura: "666ef7438d1b4351383e6a400d8c0b1372c31a8cf49d416ce4bbdab78445911e"
    sha256 cellar: :any,                 sonoma:        "1daabc3991fdcb0bf124a0c836a4f58546b5b940a995251ad1c2222c01c4bc33"
    sha256 cellar: :any,                 ventura:       "c2b06fb2567d93f54d5ab86662aaa68e8aaa8d870cf1913f5a88770d35f0a0fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5813a2bfa6606edf0e917c40730f99c041fb6f80d33bda806fb95c6f5c283157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdd3215c373c647f4c9d74dfe93e2da68c0127647c28467ae67febe89a7acd98"
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
