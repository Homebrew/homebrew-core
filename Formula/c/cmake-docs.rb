class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.3.2/cmake-4.3.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.3.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.3.2.tar.gz"
  sha256 "b0231eb39b3c3cabdc568c619df78208a7bd95ea10c9b2236d61218bac1b367d"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24d0799e55a2dff893bc2da591fd9e6bcb9b44dbcae961358aa149b062dc2e02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24d0799e55a2dff893bc2da591fd9e6bcb9b44dbcae961358aa149b062dc2e02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24d0799e55a2dff893bc2da591fd9e6bcb9b44dbcae961358aa149b062dc2e02"
    sha256 cellar: :any_skip_relocation, sonoma:        "24d0799e55a2dff893bc2da591fd9e6bcb9b44dbcae961358aa149b062dc2e02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76d5ad6b57a0a20328e62f593c0b0eca409ad7dfe8fa44fbb19ce13090d04c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76d5ad6b57a0a20328e62f593c0b0eca409ad7dfe8fa44fbb19ce13090d04c03"
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build

  def install
    args = %w[
      -DCMAKE_DOC_DIR=share/doc/cmake
      -DCMAKE_MAN_DIR=share/man
      -DSPHINX_MAN=ON
      -DSPHINX_HTML=ON
    ]
    system "cmake", "-S", "Utilities/Sphinx", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_path_exists share/"doc/cmake/html"
    assert_path_exists man
  end
end
