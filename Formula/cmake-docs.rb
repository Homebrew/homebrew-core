class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.22.3/cmake-3.22.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.22.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.22.3.tar.gz"
  sha256 "9f8469166f94553b6978a16ee29227ec49a2eb5ceb608275dec40d8ae0d1b5a0"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf7e7d46c4d96de608a78099985e088bc18e25ad20f16a339457e01cc0416794"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf7e7d46c4d96de608a78099985e088bc18e25ad20f16a339457e01cc0416794"
    sha256 cellar: :any_skip_relocation, monterey:       "df4b36a4e3d23376179630de46bde16db1d603140e34e2608e7c3b2f99384308"
    sha256 cellar: :any_skip_relocation, big_sur:        "df4b36a4e3d23376179630de46bde16db1d603140e34e2608e7c3b2f99384308"
    sha256 cellar: :any_skip_relocation, catalina:       "df4b36a4e3d23376179630de46bde16db1d603140e34e2608e7c3b2f99384308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf7e7d46c4d96de608a78099985e088bc18e25ad20f16a339457e01cc0416794"
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
