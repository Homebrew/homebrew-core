class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://alembic.io"
  url "https://github.com/alembic/alembic/archive/1.8.5.tar.gz"
  sha256 "180a12f08d391cd89f021f279dbe3b5423b1db751a9898540c8059a45825c2e9"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/alembic/alembic.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7d0f784a0a6564a113eb74cc8d5f28a354fca2efe9ddc0f68a2965eff844b912"
    sha256 cellar: :any,                 arm64_monterey: "0ceadb2a9b215d2cb5dbe81f54264d6219625f4bd12a03272699fdf0d5c6d2eb"
    sha256 cellar: :any,                 arm64_big_sur:  "ffa0a060fbc70b5b164024c4551a6a6b62a3772ca402c6f8311a8eb18c2631bb"
    sha256 cellar: :any,                 ventura:        "ee7cd38f57c819d15ddaacbb1b73835c95daef95f6897444311e179c82ecf4cd"
    sha256 cellar: :any,                 monterey:       "8f01095690c9f319e75f6b47f784134e4c7b1a445b6d85490dafcf25a6875b46"
    sha256 cellar: :any,                 big_sur:        "953292d9c490f5e9925a760c588ca9cb68153cd4db018e8f3f4a7ed2cd92ebd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1280691814dc7b43abccf9df9a79c7bacc55011bef40769ffba86ffd26af467d"
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
