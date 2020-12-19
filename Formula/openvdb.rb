class Openvdb < Formula
  desc "Sparse volume processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/v7.2.0.tar.gz"
  sha256 "81ff2758e3900e5d4022fde0149d63387167db8adaf5c0ace1456dad3a012d1d"
  license "MPL-2.0"
  head "https://github.com/AcademySoftwareFoundation/openvdb.git"

  bottle do
    rebuild 1
    sha256 "9b19f5e3486376fa6ec29d40f4b6517725d377320674d5ddb5ec26c4cfc1bb3e" => :big_sur
    sha256 "4259cbdb907f5190f19ef9aa14cea92e68f94513a5ab37c10f7c5f81f51bfaf9" => :catalina
    sha256 "bd7827344942ebbc393beaecec6e58d55e2ab5d4ba7204deaf5f5aeeba4f4de2" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "c-blosc"
  depends_on "glfw"
  depends_on "ilmbase"
  depends_on "jemalloc"
  depends_on "openexr"
  depends_on "tbb"

  resource "test_file" do
    url "https://artifacts.aswf.io/io/aswf/openvdb/models/cube.vdb/1.0.0/cube.vdb-1.0.0.zip"
    sha256 "05476e84e91c0214ad7593850e6e7c28f777aa4ff0a1d88d91168a7dd050f922"
  end

  def install
    cmake_args = [
      "-DDISABLE_DEPENDENCY_VERSION_CHECKS=ON",
      "-DOPENVDB_BUILD_DOCS=ON",
    ]

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, *cmake_args
      system "make", "install"
    end
  end

  test do
    resource("test_file").stage testpath
    system "#{bin}/vdb_print", "-m", "cube.vdb"
  end
end
