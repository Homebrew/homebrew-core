class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://alembic.io"
  url "https://github.com/alembic/alembic/archive/refs/tags/1.8.7.tar.gz"
  sha256 "3590f51f82e3675bb907f7a6a7149a76c06c23ef25d153e64391bcd22d86cc8c"
  license "BSD-3-Clause"
  head "https://github.com/alembic/alembic.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3edd7f3c3ebc3b64fdaa1130f865f91b307e772efd256d5fda086bc930c3e6bc"
    sha256 cellar: :any,                 arm64_sonoma:  "f9d36ca1955b740cbc377fe5c655ab99fcf14144e8cd906a06e1340e7b9a4d57"
    sha256 cellar: :any,                 arm64_ventura: "0d63d70231fd1f49bc0930ff0f47c6ada8ffa3c09d43edf845a74394cfb75893"
    sha256 cellar: :any,                 sonoma:        "0ab1ce5ab65809f87b3566552cb9d2fee7a2f2126a620b9b8140785e2b0cda6a"
    sha256 cellar: :any,                 ventura:       "149e6d1b898efa42b1e6aba279b7aff05acf5ccdefaa3685bfdb39ab72eba61f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afa6ea2eb2307d8e4951ef0e24130abcc4137190dbc443834e56c3467abade5a"
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
