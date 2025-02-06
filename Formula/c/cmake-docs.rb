class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.5/cmake-3.31.5.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.31.5.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.31.5.tar.gz"
  sha256 "66fb53a145648be56b46fa9e8ccade3a4d0dfc92e401e52ce76bdad1fea43d27"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40e6d495347f9ad6cc00c4c6acf5e9964a34fb34dac3d6b8653104638dcf1fa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40e6d495347f9ad6cc00c4c6acf5e9964a34fb34dac3d6b8653104638dcf1fa9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40e6d495347f9ad6cc00c4c6acf5e9964a34fb34dac3d6b8653104638dcf1fa9"
    sha256 cellar: :any_skip_relocation, sonoma:        "97eb8bd7f38481fc13560827051581647d01a61efef311fa3b560dc93576e814"
    sha256 cellar: :any_skip_relocation, ventura:       "97eb8bd7f38481fc13560827051581647d01a61efef311fa3b560dc93576e814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40e6d495347f9ad6cc00c4c6acf5e9964a34fb34dac3d6b8653104638dcf1fa9"
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
