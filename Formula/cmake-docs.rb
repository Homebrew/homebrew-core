class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.24.2/cmake-3.24.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.24.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.24.2.tar.gz"
  sha256 "0d9020f06f3ddf17fb537dc228e1a56c927ee506b486f55fe2dc19f69bf0c8db"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34668ff1872bc7cb6acda3bd1e1cd8c0151b4d81bd7c9dc33787c0c6b4921b55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34668ff1872bc7cb6acda3bd1e1cd8c0151b4d81bd7c9dc33787c0c6b4921b55"
    sha256 cellar: :any_skip_relocation, monterey:       "cd60c83393cc001950ee7539bcfc14017166d15c9a11367e415a1f2a7f7b5dfa"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd60c83393cc001950ee7539bcfc14017166d15c9a11367e415a1f2a7f7b5dfa"
    sha256 cellar: :any_skip_relocation, catalina:       "cd60c83393cc001950ee7539bcfc14017166d15c9a11367e415a1f2a7f7b5dfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34668ff1872bc7cb6acda3bd1e1cd8c0151b4d81bd7c9dc33787c0c6b4921b55"
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
