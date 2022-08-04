class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.24.0/cmake-3.24.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.24.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.24.0.tar.gz"
  sha256 "c2b61f7cdecb1576cad25f918a8f42b8685d88a832fd4b62b9e0fa32e915a658"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65f20efa7e1f678bdf5045cf46f366f8a29703473802e43be62c573b3626c044"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65f20efa7e1f678bdf5045cf46f366f8a29703473802e43be62c573b3626c044"
    sha256 cellar: :any_skip_relocation, monterey:       "2286ee261197d8a19f056ad5ed342662c818a1661b8bbb700a97834795650260"
    sha256 cellar: :any_skip_relocation, big_sur:        "2286ee261197d8a19f056ad5ed342662c818a1661b8bbb700a97834795650260"
    sha256 cellar: :any_skip_relocation, catalina:       "2286ee261197d8a19f056ad5ed342662c818a1661b8bbb700a97834795650260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65f20efa7e1f678bdf5045cf46f366f8a29703473802e43be62c573b3626c044"
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
