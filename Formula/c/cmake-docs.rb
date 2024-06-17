class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.29.5/cmake-3.29.5.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.29.5.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.29.5.tar.gz"
  sha256 "dd63da7d763c0db455ca232f2c443f5234fe0b11f8bd6958a81d29cc987dfd6e"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31b668bf2d4f61c7a870767c78c96c5a71b98e6d06afbd3859b947d944eb3e4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31b668bf2d4f61c7a870767c78c96c5a71b98e6d06afbd3859b947d944eb3e4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31b668bf2d4f61c7a870767c78c96c5a71b98e6d06afbd3859b947d944eb3e4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7909134cfaf9d2f188dc0c584e9f5c23d8569f90483e07b1c7f558be583203c"
    sha256 cellar: :any_skip_relocation, ventura:        "e7909134cfaf9d2f188dc0c584e9f5c23d8569f90483e07b1c7f558be583203c"
    sha256 cellar: :any_skip_relocation, monterey:       "e7909134cfaf9d2f188dc0c584e9f5c23d8569f90483e07b1c7f558be583203c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31b668bf2d4f61c7a870767c78c96c5a71b98e6d06afbd3859b947d944eb3e4d"
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
