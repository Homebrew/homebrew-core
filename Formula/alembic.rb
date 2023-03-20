class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://alembic.io"
  url "https://github.com/alembic/alembic/archive/1.8.5.tar.gz"
  sha256 "180a12f08d391cd89f021f279dbe3b5423b1db751a9898540c8059a45825c2e9"
  license "BSD-3-Clause"
  head "https://github.com/alembic/alembic.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7bb000eb90474a22b53b828e2140d26adbb5ddbc78ee42b5a8c9dd0447ac493c"
    sha256 cellar: :any,                 arm64_monterey: "e87eb223819f98ce0582e3ec932ef8fbb478c85ce93ad99fd9f90a0a56aae4b3"
    sha256 cellar: :any,                 arm64_big_sur:  "ef2aa27c42f96f5a1ae9469e75d704bc24458e018462ed0196acfd37697b2ab0"
    sha256 cellar: :any,                 ventura:        "c1fa0666f63a047c455fb9f00feca8ed82e2c84c2a1c6d1883ff41e507d3b715"
    sha256 cellar: :any,                 monterey:       "edc9109326c4e97dedea1b7d07b5e6957f242f67eeb17eebcb6f1da1b6ae8047"
    sha256 cellar: :any,                 big_sur:        "1fddf85cb8102d9c7f94b3595f65b7aad961d138797a0805df17f5b722cb3130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d41d701580f8e183deb9c542ae98065402e9ee9f4fc631cc3b4ae304c2af1f1f"
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
