class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://alembic.io"
  url "https://github.com/alembic/alembic/archive/1.8.4.tar.gz"
  sha256 "e0fe1e16e6ec9a699b5f016f9e0ed31a384a008cfd9184f31253e2e096b1afda"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/alembic/alembic.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "03703f33440ab833d334aaf2b01190d65512efdc13461228ed55fd0f9fcfcfe7"
    sha256 cellar: :any,                 arm64_monterey: "09d1cab851add8faa5c79dbafafb6844bbc67dc089cee801a3dfd165ba0ba37a"
    sha256 cellar: :any,                 arm64_big_sur:  "096dcbb5da9dc5e4083185dab94de7da70437e1482934f02d3d91bd3cbea84a9"
    sha256 cellar: :any,                 ventura:        "09dc0d2bbf92b5ae6a102e3e77de63e0883b11deef3492ac27df272e8f7fb281"
    sha256 cellar: :any,                 monterey:       "cca80eefc7f37e286b2a8636170756accd85a639a93251760c49fbf49a9a4886"
    sha256 cellar: :any,                 big_sur:        "e48d101f4d7e434e9f6b0f5aadc08887d901a58a2ff40603f77a7e8adca4e035"
    sha256 cellar: :any,                 catalina:       "ff5263fd1a8c9e937e657a7ec3b8a736ea26e0d34edfec57a090602ab154f3f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bade8c0ff094e72a2bd34eb13201cd63ac6d6756b766366d2a1a1411f4085bed"
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
