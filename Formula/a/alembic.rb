class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://www.alembic.io/"
  url "https://github.com/alembic/alembic/archive/refs/tags/1.8.10.tar.gz"
  sha256 "06c9172faf29e9fdebb7be99621ca18b32b474f8e481238a159c87d16b298553"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/alembic/alembic.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "3a8207a61469b1d25e6b2b39968491931f8eeba421877ea6a24ec38044eaf9cd"
    sha256 cellar: :any,                 arm64_sequoia: "8d40cf612fb27eb0304df9d159573dcf90645d51b071f3d8a16b3dce713562fd"
    sha256 cellar: :any,                 arm64_sonoma:  "059f167ec443be9b67097c3ad8d20139cef7d88893e188e7dcf83097851592ea"
    sha256 cellar: :any,                 sonoma:        "819f54e39924e2e0ccbc1c00b74e7a9e4846497e0a6e0383543e4e037cd4b993"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eefaabb5c8e230694b7e045df9e11afa70c1b4864fc26621b19a469ef15b1317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03de0e5c013bd50a6cc411a5d4fd9200edd9b1273238327ab16f1e705ab1feb5"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on "imath"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[
      -DUSE_PRMAN=OFF
      -DUSE_ARNOLD=OFF
      -DUSE_MAYA=OFF
      -DUSE_PYALEMBIC=OFF
      -DUSE_HDF5=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "prman/Tests/testdata/cube.abc"
  end

  test do
    assert_match "root", shell_output("#{bin}/abcls #{pkgshare}/cube.abc")
  end
end
