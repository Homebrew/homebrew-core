class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://alembic.io"
  url "https://github.com/alembic/alembic/archive/refs/tags/1.8.6.tar.gz"
  sha256 "c572ebdea3a5f0ce13774dd1fceb5b5815265cd1b29d142cf8c144b03c131c8c"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/alembic/alembic.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2d570e9a98c50078372b7a61be5ecd48fcf17c6054ac50dfdf65a02cd96f5e36"
    sha256 cellar: :any,                 arm64_ventura:  "08582785ae66e4582d2fae85c48399a9d6d3848324e7b91421bac090915ec59f"
    sha256 cellar: :any,                 arm64_monterey: "d614a766f6b4a4cf06f5438e5247140341ac00bd39127cf1691642cd354e2f0d"
    sha256 cellar: :any,                 sonoma:         "2c177245013d8f721bb622feb8991a7a3b8070ca4dc4aaed3c65321a17bd0ffb"
    sha256 cellar: :any,                 ventura:        "03646ed6ecd641118dc5f2dd90cbedc964eb7e2f48a0b54dd71958e9f899865f"
    sha256 cellar: :any,                 monterey:       "fdea051aa486e27e291cdc2326b9b010186668bb0c2444c321a6540badf0e057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e4dddeb80ad2f92a034904f0407c10f2c344955eed55ba77430c4f2ac38c2d9"
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
