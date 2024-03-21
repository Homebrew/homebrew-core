class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.29.0/cmake-3.29.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.29.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.29.0.tar.gz"
  sha256 "a0669630aae7baa4a8228048bf30b622f9e9fd8ee8cedb941754e9e38686c778"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22a9ba7f6f7b402a3c5e82b76f24271dc7f08db829caebc77e7a31ace995c7e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22a9ba7f6f7b402a3c5e82b76f24271dc7f08db829caebc77e7a31ace995c7e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22a9ba7f6f7b402a3c5e82b76f24271dc7f08db829caebc77e7a31ace995c7e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee7ca60a44d91ca544f0c8d15801ed54f1942f3b3cf39eacc177f50c5c32bf75"
    sha256 cellar: :any_skip_relocation, ventura:        "ee7ca60a44d91ca544f0c8d15801ed54f1942f3b3cf39eacc177f50c5c32bf75"
    sha256 cellar: :any_skip_relocation, monterey:       "ee7ca60a44d91ca544f0c8d15801ed54f1942f3b3cf39eacc177f50c5c32bf75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22a9ba7f6f7b402a3c5e82b76f24271dc7f08db829caebc77e7a31ace995c7e7"
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
