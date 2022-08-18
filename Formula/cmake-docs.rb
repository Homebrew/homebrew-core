class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.24.1/cmake-3.24.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.24.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.24.0.tar.gz"
  sha256 "4931e277a4db1a805f13baa7013a7757a0cbfe5b7932882925c7061d9d1fa82b"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c7df40f43b974f9367d45e5150309e8c391629ffb03b3caf283f8137fe7b4c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c7df40f43b974f9367d45e5150309e8c391629ffb03b3caf283f8137fe7b4c1"
    sha256 cellar: :any_skip_relocation, monterey:       "bc9bc126beb77f0135ea0dd9e58c632a0d2eb2a5d9e68f16b53aab3692416560"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc9bc126beb77f0135ea0dd9e58c632a0d2eb2a5d9e68f16b53aab3692416560"
    sha256 cellar: :any_skip_relocation, catalina:       "bc9bc126beb77f0135ea0dd9e58c632a0d2eb2a5d9e68f16b53aab3692416560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c7df40f43b974f9367d45e5150309e8c391629ffb03b3caf283f8137fe7b4c1"
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
