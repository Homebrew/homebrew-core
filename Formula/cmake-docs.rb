class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  # Keep in sync with cmake.
  url "https://github.com/Kitware/CMake/releases/download/v3.21.3/cmake-3.21.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.21.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.21.3.tar.gz"
  sha256 "d14d06df4265134ee42c4d50f5a60cb8b471b7b6a47da8e5d914d49dd783794f"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bb9b954ac614fa5a785ef54a98b296deff58f212194759f66cd19afa0b146999"
    sha256 cellar: :any_skip_relocation, big_sur:       "3341757894ff5a555eb030f048c0d5d2b08e366d9f3327e68672e5a0210dbf2e"
    sha256 cellar: :any_skip_relocation, catalina:      "3341757894ff5a555eb030f048c0d5d2b08e366d9f3327e68672e5a0210dbf2e"
    sha256 cellar: :any_skip_relocation, mojave:        "3341757894ff5a555eb030f048c0d5d2b08e366d9f3327e68672e5a0210dbf2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb9b954ac614fa5a785ef54a98b296deff58f212194759f66cd19afa0b146999"
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build

  def install
    system "cmake", "-S", "Utilities/Sphinx", "-B", "build", *std_cmake_args,
                                                             "-DCMAKE_DOC_DIR=share/doc/cmake",
                                                             "-DCMAKE_MAN_DIR=share/man",
                                                             "-DSPHINX_MAN=ON",
                                                             "-DSPHINX_HTML=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_path_exists share/"doc/cmake/html"
    assert_path_exists man
  end
end
