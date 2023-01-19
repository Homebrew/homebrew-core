class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.25.2/cmake-3.25.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.25.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.25.2.tar.gz"
  sha256 "c026f22cb931dd532f648f087d587f07a1843c6e66a3dfca4fb0ea21944ed33c"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce71fc7d5c45acf607921433583cbe5f2a1b45889a2e33f2a7d4cb955f37bc4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce71fc7d5c45acf607921433583cbe5f2a1b45889a2e33f2a7d4cb955f37bc4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce71fc7d5c45acf607921433583cbe5f2a1b45889a2e33f2a7d4cb955f37bc4a"
    sha256 cellar: :any_skip_relocation, ventura:        "4b420e82e1dac0438c2a453e2e3c395cbab98e4df0ae1805e68155dbfa51b72b"
    sha256 cellar: :any_skip_relocation, monterey:       "4b420e82e1dac0438c2a453e2e3c395cbab98e4df0ae1805e68155dbfa51b72b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b420e82e1dac0438c2a453e2e3c395cbab98e4df0ae1805e68155dbfa51b72b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce71fc7d5c45acf607921433583cbe5f2a1b45889a2e33f2a7d4cb955f37bc4a"
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
