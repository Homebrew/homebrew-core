class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.2.1/cmake-4.2.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.2.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.2.1.tar.gz"
  sha256 "414aacfac54ba0e78e64a018720b64ed6bfca14b587047b8b3489f407a14a070"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a3f80f250ffddcef9b0bac094fe317b1b41be2f4a07f24f61bb203f5fae70856"
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
