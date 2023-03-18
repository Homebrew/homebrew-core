class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.26.0/cmake-3.26.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.26.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.26.0.tar.gz"
  sha256 "4256613188857e95700621f7cdaaeb954f3546a9249e942bc2f9b3c26e381365"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31bb6ac32f52d12e549dcf102e6919c3461f35af0a647835b22c98118a29315c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31bb6ac32f52d12e549dcf102e6919c3461f35af0a647835b22c98118a29315c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31bb6ac32f52d12e549dcf102e6919c3461f35af0a647835b22c98118a29315c"
    sha256 cellar: :any_skip_relocation, ventura:        "4f7da149202d2f1e0b4d9798c63d8d3369a58e7f271a77bf94b7d39b9fd01507"
    sha256 cellar: :any_skip_relocation, monterey:       "4f7da149202d2f1e0b4d9798c63d8d3369a58e7f271a77bf94b7d39b9fd01507"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f7da149202d2f1e0b4d9798c63d8d3369a58e7f271a77bf94b7d39b9fd01507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31bb6ac32f52d12e549dcf102e6919c3461f35af0a647835b22c98118a29315c"
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
