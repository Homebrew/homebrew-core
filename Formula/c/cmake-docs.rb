class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.27.7/cmake-3.27.7.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.27.7.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.27.7.tar.gz"
  sha256 "08f71a106036bf051f692760ef9558c0577c42ac39e96ba097e7662bd4158d8e"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f84b3fcf6c137754156590d3028d4ba103a714e6ddb2998133b73d6de172737"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f84b3fcf6c137754156590d3028d4ba103a714e6ddb2998133b73d6de172737"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f84b3fcf6c137754156590d3028d4ba103a714e6ddb2998133b73d6de172737"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed2256a403f0b0440e1e1aaa5f0a0dc3c3aa70358b75df3c4ddfa51c7f90b6f3"
    sha256 cellar: :any_skip_relocation, ventura:        "ed2256a403f0b0440e1e1aaa5f0a0dc3c3aa70358b75df3c4ddfa51c7f90b6f3"
    sha256 cellar: :any_skip_relocation, monterey:       "ed2256a403f0b0440e1e1aaa5f0a0dc3c3aa70358b75df3c4ddfa51c7f90b6f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f84b3fcf6c137754156590d3028d4ba103a714e6ddb2998133b73d6de172737"
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
