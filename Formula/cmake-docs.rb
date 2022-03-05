class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.22.3/cmake-3.22.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.22.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.22.3.tar.gz"
  sha256 "9f8469166f94553b6978a16ee29227ec49a2eb5ceb608275dec40d8ae0d1b5a0"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19e8cfc11858d0d740c9c8b32363df6ac30949432e8f6e2c8ac8384779c5ed93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19e8cfc11858d0d740c9c8b32363df6ac30949432e8f6e2c8ac8384779c5ed93"
    sha256 cellar: :any_skip_relocation, monterey:       "cc8b60e787c0c23960f0e0052cc4d38c8b566f0eb333d1995e4d87023a003442"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc8b60e787c0c23960f0e0052cc4d38c8b566f0eb333d1995e4d87023a003442"
    sha256 cellar: :any_skip_relocation, catalina:       "cc8b60e787c0c23960f0e0052cc4d38c8b566f0eb333d1995e4d87023a003442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19e8cfc11858d0d740c9c8b32363df6ac30949432e8f6e2c8ac8384779c5ed93"
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
