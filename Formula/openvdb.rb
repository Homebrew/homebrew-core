class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/v10.0.0.tar.gz"
  sha256 "fb0b54500464903a2334625e43f3719bd107ab0cf538d7762fd0185086a17a6d"
  license "MPL-2.0"
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3a13dcdc2a4d5a80641b50566d42dcacdef5eb102f0b25b459cf86ad22db53bb"
    sha256 cellar: :any,                 arm64_big_sur:  "421d837ff164d70af6e9ca6c917bdee1e8348e3f461444d05d3ccac487cbcd8b"
    sha256 cellar: :any,                 monterey:       "031757fa9a7b3b2a87158182f77ee752461dd030c4a1171876475bcbe72462ce"
    sha256 cellar: :any,                 big_sur:        "ef0cb3215976b98d1b4749a96264eb2137e6245699007322c774dda76e20425c"
    sha256 cellar: :any,                 catalina:       "f2110c85d80aede034f7c8f83393db883b67d43f36a76702a93a5bac47e33e57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69b854fe914d3fb8a42ad03ae5a7d5301a9bb1395167861c82c54981a14a2371"
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
