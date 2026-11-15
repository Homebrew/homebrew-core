class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/refs/tags/v14.0.0.tar.gz"
  sha256 "2c38592a42a9dc1f3e9749418cc9d286d88ed912232dafee954ce5156174e5b0"
  license "Apache-2.0"
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ea5c68ef31d5d0237ddf5e232c49f02bf944848dde09d11e44c105e9c73f07eb"
    sha256 cellar: :any, arm64_tahoe:       "35ddf4d68eeba9c4a981780be45c602e5e83ca2d41ecfb36339ff806d34abec6"
    sha256 cellar: :any, arm64_sequoia:     "a51529bb6a783246010c75e71e318fb50cf9804773346ec76a446d99897f9033"
    sha256 cellar: :any, arm64_linux:       "dc16e7f6ea3385843ab2cea6a89ff82934be6c1fab679f664f34da87e0bbe0df"
    sha256 cellar: :any, x86_64_linux:      "41e3e7721db850fa5fdf632a027d183cf329eba77041f385053548d015b4938f"
  end

  depends_on "cmake" => :build

  depends_on "jemalloc"
  depends_on "tbb"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "homebrew-test_file", :test do
    url "https://artifacts.aswf.io/io/aswf/openvdb/models/cube.vdb/1.0.0/cube.vdb-1.0.0.zip"
    sha256 "05476e84e91c0214ad7593850e6e7c28f777aa4ff0a1d88d91168a7dd050f922"
  end

  allow_network_access! :test

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
    testpath.install resource("homebrew-test_file")
    system bin/"vdb_print", "-m", "cube.vdb"
  end
end
