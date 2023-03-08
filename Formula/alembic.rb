class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://alembic.io"
  url "https://github.com/alembic/alembic/archive/1.8.4.tar.gz"
  sha256 "e0fe1e16e6ec9a699b5f016f9e0ed31a384a008cfd9184f31253e2e096b1afda"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/alembic/alembic.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e56740fefdee340d0c1e2250d6f1fe3f7445cec8d477bab24de34b594a57f84d"
    sha256 cellar: :any,                 arm64_monterey: "7167289cc28233076d058d606ca28e3fcf561153111f4083271aadf72da9f599"
    sha256 cellar: :any,                 arm64_big_sur:  "4123919fbebdf099e4a56189de9372dd6e7b980eab6893fbe4fe0308a278e3cf"
    sha256 cellar: :any,                 ventura:        "7490f5a0d9ce13d9703d2e93f52999a66f089530d97d2ed71109e58483935008"
    sha256 cellar: :any,                 monterey:       "9ba5a3e4b5896001f96daef6a4fc231e14731d05e647b01d3d34a905765a5961"
    sha256 cellar: :any,                 big_sur:        "317a32fad945a39eed8ef5c4540ba1d5ced3cbaa7b95174971e009e3c5bfae24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeac00e2f55eaf0aa1ddeab45f91e79a58532d2c7885853b9e496a30483ad020"
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
