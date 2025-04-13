class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://www.alembic.io/"
  url "https://github.com/alembic/alembic/archive/refs/tags/1.8.8.tar.gz"
  sha256 "ba1f34544608ef7d3f68cafea946ec9cc84792ddf9cda3e8d5590821df71f6c6"
  license "BSD-3-Clause"
  head "https://github.com/alembic/alembic.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6a69e3e7fe9ed8794cfb70d95e5a90d4edd03fb37870d318cc2772f3d887dc57"
    sha256 cellar: :any,                 arm64_sonoma:  "a0de5bbd49ecae579210057e2fd9623bfcd5c8751ebb33638b9c498a8e896cfd"
    sha256 cellar: :any,                 arm64_ventura: "805fdb868569c1d52f0014d0fe5c33ec94351295713cabd827d6604ec59b931a"
    sha256 cellar: :any,                 sonoma:        "9b999957a0cd7bb166cbaab35e65c2b29fa7571366d7140548469cb416fa0a7e"
    sha256 cellar: :any,                 ventura:       "b0156c9b787c034db3f133800446abae92cb2d9ad778cc28e76c8e2794b9a72f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf3154912b2a9e4e2bdb3c8b96774ac964729107d0696c8edda544444693b849"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fef41d868f2c1ab7bfe69219612f1958056e6396dd5055d8320a6a952dca4e2d"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on "imath"
  depends_on "libaec"

  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args + %w[
      -DUSE_PRMAN=OFF
      -DUSE_ARNOLD=OFF
      -DUSE_MAYA=OFF
      -DUSE_PYALEMBIC=OFF
      -DUSE_HDF5=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "prman/Tests/testdata/cube.abc"
  end

  test do
    assert_match "root", shell_output("#{bin}/abcls #{pkgshare}/cube.abc")
  end
end
