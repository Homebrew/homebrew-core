class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.26.4/cmake-3.26.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.26.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.26.4.tar.gz"
  sha256 "313b6880c291bd4fe31c0aa51d6e62659282a521e695f30d5cc0d25abbd5c208"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a93e2c6b620984230760eafa3e17f8b3b4feb9a7cb0dc2832df095d33c8fd2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a93e2c6b620984230760eafa3e17f8b3b4feb9a7cb0dc2832df095d33c8fd2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a93e2c6b620984230760eafa3e17f8b3b4feb9a7cb0dc2832df095d33c8fd2f"
    sha256 cellar: :any_skip_relocation, ventura:        "5776f5042fbc09a755e3875883936844f19d3aa6524d55a8b8958b8ad38dfd4a"
    sha256 cellar: :any_skip_relocation, monterey:       "5776f5042fbc09a755e3875883936844f19d3aa6524d55a8b8958b8ad38dfd4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "5776f5042fbc09a755e3875883936844f19d3aa6524d55a8b8958b8ad38dfd4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a93e2c6b620984230760eafa3e17f8b3b4feb9a7cb0dc2832df095d33c8fd2f"
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
