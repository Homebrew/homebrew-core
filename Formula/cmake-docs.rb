class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.23.0/cmake-3.23.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.23.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.23.0.tar.gz"
  sha256 "5ab0a12f702f44013be7e19534cd9094d65cc9fe7b2cd0f8c9e5318e0fe4ac82"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bfc101da5ebe4fc790d3fd8ba940c625a06e642c42860fcb81b0db6687d827a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bfc101da5ebe4fc790d3fd8ba940c625a06e642c42860fcb81b0db6687d827a"
    sha256 cellar: :any_skip_relocation, monterey:       "f1578f3347f7ce6c5df95b95a9fb81c3aa585668a9acea36f24b03e68265f19f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1578f3347f7ce6c5df95b95a9fb81c3aa585668a9acea36f24b03e68265f19f"
    sha256 cellar: :any_skip_relocation, catalina:       "f1578f3347f7ce6c5df95b95a9fb81c3aa585668a9acea36f24b03e68265f19f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bfc101da5ebe4fc790d3fd8ba940c625a06e642c42860fcb81b0db6687d827a"
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
