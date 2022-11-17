class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.25.0/cmake-3.25.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.25.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.25.0.tar.gz"
  sha256 "306463f541555da0942e6f5a0736560f70c487178b9d94a5ae7f34d0538cdd48"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f45a9e05e9db1ba80abc234162d45f70ea1f63b0dee5e4ac15e3d404ea8473c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f45a9e05e9db1ba80abc234162d45f70ea1f63b0dee5e4ac15e3d404ea8473c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f45a9e05e9db1ba80abc234162d45f70ea1f63b0dee5e4ac15e3d404ea8473c8"
    sha256 cellar: :any_skip_relocation, monterey:       "75f39c0d04973ac0cf7330e4aa1cbc0d888aa7fac52dbe4b1e3244da20e341b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "75f39c0d04973ac0cf7330e4aa1cbc0d888aa7fac52dbe4b1e3244da20e341b3"
    sha256 cellar: :any_skip_relocation, catalina:       "75f39c0d04973ac0cf7330e4aa1cbc0d888aa7fac52dbe4b1e3244da20e341b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f45a9e05e9db1ba80abc234162d45f70ea1f63b0dee5e4ac15e3d404ea8473c8"
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
