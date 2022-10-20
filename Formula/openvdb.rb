class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/v10.0.0.tar.gz"
  sha256 "fb0b54500464903a2334625e43f3719bd107ab0cf538d7762fd0185086a17a6d"
  license "MPL-2.0"
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3c6573a80c64d2113eadebb6588a74e214412230ad431ae11222c263e1e48b5b"
    sha256 cellar: :any,                 arm64_big_sur:  "bb6600f6bef2d7a79c43f1531afca274a113dda161c2ad48541462b945db62f9"
    sha256 cellar: :any,                 monterey:       "bc3db85b839c088af4271ffd305ca1084aea3b6035ef00a9571ec10702438e02"
    sha256 cellar: :any,                 big_sur:        "53249d9fb08ef2fadd93f19c280ad6359a662c52b0aa25dc0a6bf5dd049d42aa"
    sha256 cellar: :any,                 catalina:       "c16844a686000d6074da1cc7d57918b7f84a5783a1720ae65451621989e53dde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e0b5ebef2b1e369f90e4ede4f30eebe3268a33cddf317624ebe6026e0997154"
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
