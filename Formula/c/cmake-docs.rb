class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.1.3/cmake-4.1.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.1.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.1.3.tar.gz"
  sha256 "765879a53d178bf1e1509768de4c9a672dabaa20047a9f3809571558e783be88"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8867e563fde2d33267dec0efc6219bdbcd1beb14d8f8c21d38d128a020a5cd5d"
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build

  def install
    args = %w[
      -DCMAKE_DOC_DIR=share/doc/cmake
      -DCMAKE_MAN_DIR=share/man
      -DSPHINX_MAN=ON
      -DSPHINX_HTML=ON
    ]
    system "cmake", "-S", "Utilities/Sphinx", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_path_exists share/"doc/cmake/html"
    assert_path_exists man
  end
end
