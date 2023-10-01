class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.27.6/cmake-3.27.6.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.27.6.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.27.6.tar.gz"
  sha256 "ef3056df528569e0e8956f6cf38806879347ac6de6a4ff7e4105dc4578732cfb"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d07c7d3fa9bac89acfefe95a634c2073f1e2f89f9f477f4259b2913cb74064f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d07c7d3fa9bac89acfefe95a634c2073f1e2f89f9f477f4259b2913cb74064f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d07c7d3fa9bac89acfefe95a634c2073f1e2f89f9f477f4259b2913cb74064f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d07c7d3fa9bac89acfefe95a634c2073f1e2f89f9f477f4259b2913cb74064f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "1bef147810c6d0d50fc325044226f3d4beff600a453346505eab3a28d3a5c583"
    sha256 cellar: :any_skip_relocation, ventura:        "1bef147810c6d0d50fc325044226f3d4beff600a453346505eab3a28d3a5c583"
    sha256 cellar: :any_skip_relocation, monterey:       "1bef147810c6d0d50fc325044226f3d4beff600a453346505eab3a28d3a5c583"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bef147810c6d0d50fc325044226f3d4beff600a453346505eab3a28d3a5c583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d07c7d3fa9bac89acfefe95a634c2073f1e2f89f9f477f4259b2913cb74064f6"
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
