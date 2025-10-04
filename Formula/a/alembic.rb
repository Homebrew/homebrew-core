class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://www.alembic.io/"
  url "https://github.com/alembic/alembic/archive/refs/tags/1.8.9.tar.gz"
  sha256 "8c59c10813feee917d262c71af77d6fa3db1acaf7c5fecfd4104167077403955"
  license "BSD-3-Clause"
  head "https://github.com/alembic/alembic.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fe4175963e13cf035e6565485469cc17b66c12bbbe333e705f4111c52bedbe61"
    sha256 cellar: :any,                 arm64_sequoia: "ec6e903dd3d682d599cc953dd768e9f9a6de69996c15e03d5aeb008e1c1abdcd"
    sha256 cellar: :any,                 arm64_sonoma:  "f7093bfea4c17d6ff6257501785677aa56a5c158d469b89932b7dd6a73a57595"
    sha256 cellar: :any,                 sonoma:        "7e4baa1809aae0982320bac1d6c2d54b28e47c253146c3890caf1bde15e453b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4371cff241b0231dbd14de3c5b65e092772902a714b3b7da72eb080412e63ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d79b74b60858311b6619973fcb81ff06363bc8e2838e90835be8e1ce1d01f79f"
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
