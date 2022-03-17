class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://alembic.io"
  url "https://github.com/alembic/alembic/archive/1.8.3.tar.gz"
  sha256 "b0bc74833bff118a869e81e6acb810a58797e77ef63143954b2f8e817c7f65cb"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/alembic/alembic.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "20af15e4b2c129acfdc29ece5ab967bf69feb9a581e80e14c19062467f29487c"
    sha256 cellar: :any,                 arm64_big_sur:  "40bd5931e665dfa050f071522734b0f414b1fad4744e7485cf2426007977fc3f"
    sha256 cellar: :any,                 monterey:       "dacc5d8d8703ffdc042f0a199b7537634a3921752f8e7ed5202eeac086d8f1b3"
    sha256 cellar: :any,                 big_sur:        "e7e91332c264c371051de27322c77cacc5513227566129206983c46718230aa4"
    sha256 cellar: :any,                 catalina:       "f9a875fef0cb0efb4e15e3f054bd9c6e2110677edef22766b92f61fb05c2a549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a60ba5cb5042b72122e86d346e1964a8d2fc2bcc42dcba1976cda0c5017ef57d"
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
