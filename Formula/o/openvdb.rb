class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/refs/tags/v13.1.0.tar.gz"
  sha256 "21659ef2330a06805519dd8d4369375f181a0dfee205b0180da69b4edd3329ae"
  license "MPL-2.0"
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d6d1bbec81084b954da53953fd731fb15ef3c0e317e5f0dcedbc935f386ff3b1"
    sha256 cellar: :any, arm64_tahoe:       "b3232aa69e569b6d8bfe6bbd86fe2ff6a3a2713cb5758c5b812175155e597a8b"
    sha256 cellar: :any, arm64_sequoia:     "aa45c7506bbe697b1ee01390bcfcaa0926b28b9af5a2e3419751ff912a48c0c0"
    sha256 cellar: :any, arm64_linux:       "593859d1b2b9280587f5634f9525b86de987d484d3a73cbe07d2ab3741e8f148"
    sha256 cellar: :any, x86_64_linux:      "7b2bb663bee836bfded19cdd733b3c9a64c908ff7eca1d10d00a71729940b271"
  end

  depends_on "cmake" => :build

  depends_on "boost"
  depends_on "c-blosc"
  depends_on "jemalloc"
  depends_on "openexr"
  depends_on "tbb"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = [
      "-DDISABLE_DEPENDENCY_VERSION_CHECKS=ON",
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
