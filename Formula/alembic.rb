class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://alembic.io"
  url "https://github.com/alembic/alembic/archive/1.8.3.tar.gz"
  sha256 "b0bc74833bff118a869e81e6acb810a58797e77ef63143954b2f8e817c7f65cb"
  license "BSD-3-Clause"
  head "https://github.com/alembic/alembic.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4a2c94fe2b8f8c34024a4be204b4db96ada1cdd2f85457b87519a5618f130056"
    sha256 cellar: :any,                 arm64_big_sur:  "1c7b635a35b4444ad15e39a62e41acb55b895b06e6acf4d82bd0dfb3b06306c3"
    sha256 cellar: :any,                 monterey:       "9133bdb4d6d930c43cc373931218d930ab4fe8eed0aa6d0cdfa40d3945d48371"
    sha256 cellar: :any,                 big_sur:        "978c247938f12a2f093e3e3caa0d9506186fc2fc922b63c328a9be08c660cc67"
    sha256 cellar: :any,                 catalina:       "b6d5ec59340dde30d36865eb37eb667459d0c5ca8bffbd220ca580ccd9b41a29"
    sha256 cellar: :any,                 mojave:         "c10d048c3c97a4dbd228f9c42b8b2c54e9b6eb4ffceb39e300f5676013547c25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16bb62b32e9e5ad09de62602a5b31c262610d4be59bc862f00b8fc669da1add3"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on "imath"
  depends_on "szip"

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
