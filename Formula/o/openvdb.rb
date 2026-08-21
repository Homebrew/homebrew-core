class Openvdb < Formula
  desc "Sparse volumetric data processing toolkit"
  homepage "https://www.openvdb.org/"
  license "MPL-2.0"
  revision 2
  head "https://github.com/AcademySoftwareFoundation/openvdb.git", branch: "master"

  stable do
    url "https://github.com/AcademySoftwareFoundation/openvdb/archive/refs/tags/v13.0.0.tar.gz"
    sha256 "4d6a91df5f347017496fe8d22c3dbb7c4b5d7289499d4eb4d53dd2c75bb454e1"

    # Backport fix for TBB 2023+
    patch do
      url "https://github.com/AcademySoftwareFoundation/openvdb/commit/d68d0914fc6ed41cadd363bd4330c39a7fb5b1f1.patch?full_index=1"
      sha256 "f94c85535bf3d9d78bebde35d357407e12465cbda300cd6b1552092dd98fba0f"
      type :backport
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3da40ae49c875c33fe3082427990449d36b58efe4e4a521027ed4dd05df3282d"
    sha256 cellar: :any, arm64_sequoia: "fd013a66ba8876299b4fc74fc300ce40185ba276710da32bd99abaa8200a9f48"
    sha256 cellar: :any, arm64_sonoma:  "0b54747afa466e2ebbddf6292f48d93ba28de98814f780658ee526eb01a7a769"
    sha256 cellar: :any, sonoma:        "862bb3dc701dc6d140dc464b8815c3a295df83120f6b9326f8adaba650dd6c9e"
    sha256 cellar: :any, arm64_linux:   "84438cadcad65e8897d0437884d8050d9a4cac9373cd9fea0e473f8f6cfb1049"
    sha256 cellar: :any, x86_64_linux:  "5d076c1bf8fe67afe9d695d05bd0d5acb9a5c9ea02e2efa5e1170fce3d6d8956"
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
