class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.25.0/cmake-3.25.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.25.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.25.0.tar.gz"
  sha256 "306463f541555da0942e6f5a0736560f70c487178b9d94a5ae7f34d0538cdd48"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56d5fe2fc75078b6479df10d83ca69c1c2ee84d9bde15e38d73a4568bfc793c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56d5fe2fc75078b6479df10d83ca69c1c2ee84d9bde15e38d73a4568bfc793c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56d5fe2fc75078b6479df10d83ca69c1c2ee84d9bde15e38d73a4568bfc793c4"
    sha256 cellar: :any_skip_relocation, ventura:        "2f212ddbefe08890780ed03eca2342dae2a87ed74cf812b0c3c52a4bc7fa5062"
    sha256 cellar: :any_skip_relocation, monterey:       "2f212ddbefe08890780ed03eca2342dae2a87ed74cf812b0c3c52a4bc7fa5062"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f212ddbefe08890780ed03eca2342dae2a87ed74cf812b0c3c52a4bc7fa5062"
    sha256 cellar: :any_skip_relocation, catalina:       "2f212ddbefe08890780ed03eca2342dae2a87ed74cf812b0c3c52a4bc7fa5062"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56d5fe2fc75078b6479df10d83ca69c1c2ee84d9bde15e38d73a4568bfc793c4"
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
