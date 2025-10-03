class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://www.alembic.io/"
  url "https://github.com/alembic/alembic/archive/refs/tags/1.8.8.tar.gz"
  sha256 "ba1f34544608ef7d3f68cafea946ec9cc84792ddf9cda3e8d5590821df71f6c6"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/alembic/alembic.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1a9bb95d1d87e1992eec5f8af619db73a092f1310ceb14fed17a11d91e7878e9"
    sha256 cellar: :any,                 arm64_sequoia: "610f35a2e19d502e0516c4f15ed3c191847b82b235877be96363bd77bd1a0698"
    sha256 cellar: :any,                 arm64_sonoma:  "b074c31658e917a6893d25d34a51456822ef13ba793dd9d425075ae40308fcf1"
    sha256 cellar: :any,                 arm64_ventura: "e44708b138271fce33065db3d9dab357fd5ce49c2be8b1307181f7dd7f5a5ef7"
    sha256 cellar: :any,                 sonoma:        "0d29663e698cd2670be4bdc46267eb8dc82841f0d358d03f11a2591d69de5544"
    sha256 cellar: :any,                 ventura:       "86effeeb1c94481005a42613b52bfc86a037b50c4d3ae570633375ed794ea545"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f55edf0982f550426a5fb161b1b2e42681f2c1d3fce8d45b4af37dd3de0b3d73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c43f5ff65b25e5ce1ca369e5ef7f67ffb04ea5a043348537cc239b93f52938c7"
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
