class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://alembic.io"
  url "https://github.com/alembic/alembic/archive/1.8.3.tar.gz"
  sha256 "b0bc74833bff118a869e81e6acb810a58797e77ef63143954b2f8e817c7f65cb"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/alembic/alembic.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d6f162ac7821f82d52c9f255160d690a9e87200d9944297725183198cfa12dda"
    sha256 cellar: :any,                 arm64_big_sur:  "299a3284cb5e8750db7de0658b293689517dd53b43ef2fa30d7a7a925ea17107"
    sha256 cellar: :any,                 monterey:       "a4837dd18418c4c209cfe7864646137f8c4e2e07c7fb08766ee19e1d5c9c2a8a"
    sha256 cellar: :any,                 big_sur:        "03119f89473ce48243ee8942d43f189b2f9c5a0d5b3462f03df5b3fc6bbd5e52"
    sha256 cellar: :any,                 catalina:       "6516fc5e2ed5dd868e8852859e2b48c48036d6eadbc8d55d66142b68d0fc4769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dacfa0ab6c46714a1f0cb57527d16b816c57ab2a6746e17ba9b322a05b161782"
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
