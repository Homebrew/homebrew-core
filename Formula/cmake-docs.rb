class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.22.1/cmake-3.22.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.22.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.22.1.tar.gz"
  sha256 "0e998229549d7b3f368703d20e248e7ee1f853910d42704aa87918c213ea82c0"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fa7655ba0f8617bd2322c216f176a09838ed18f5f3987e41b526c4233ff22de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fa7655ba0f8617bd2322c216f176a09838ed18f5f3987e41b526c4233ff22de"
    sha256 cellar: :any_skip_relocation, monterey:       "eb6f3b077159533e85f19cb6e390804f7adc88a98bcf3cec84049ecae1b3600d"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb6f3b077159533e85f19cb6e390804f7adc88a98bcf3cec84049ecae1b3600d"
    sha256 cellar: :any_skip_relocation, catalina:       "eb6f3b077159533e85f19cb6e390804f7adc88a98bcf3cec84049ecae1b3600d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fa7655ba0f8617bd2322c216f176a09838ed18f5f3987e41b526c4233ff22de"
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
