class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://www.alembic.io/"
  url "https://github.com/alembic/alembic/archive/refs/tags/1.8.10.tar.gz"
  sha256 "06c9172faf29e9fdebb7be99621ca18b32b474f8e481238a159c87d16b298553"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/alembic/alembic.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "411f6a17ca98eccb68fedbdf99b1d8b33e5c530089e6ebcb9f599fc52e6b3d4c"
    sha256 cellar: :any,                 arm64_sequoia: "541235e4db32345a2aa4d81c4fc8cb2df213a18cebcbfc27f9815a15b89e8924"
    sha256 cellar: :any,                 arm64_sonoma:  "b4102894b97058e02f3c880c13cef0b99d6cde1bc7a29649784b6c88abb64439"
    sha256 cellar: :any,                 sonoma:        "4b431aa2bf8486d6caa1118f304beedad29f6cc31bf1bb7727db4700d3dd3325"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "146766577575f7f183fd263801906c9029e944fced561eae1af902c122aa7064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e00d209c83b7d0b5069cddfcb2ec8c69e0585723d10ab17342a0a6e58b0ca16"
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
