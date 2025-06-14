class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.0.3/cmake-4.0.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.0.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.0.3.tar.gz"
  sha256 "8d3537b7b7732660ea247398f166be892fe6131d63cc291944b45b91279f3ffb"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18befc0d468df5072a1cacd64d34e0a8ec2ab515e3c7303712d50819538af840"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18befc0d468df5072a1cacd64d34e0a8ec2ab515e3c7303712d50819538af840"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18befc0d468df5072a1cacd64d34e0a8ec2ab515e3c7303712d50819538af840"
    sha256 cellar: :any_skip_relocation, sonoma:        "01011f228e4eee6a204848b92e7e148143020695407919e6137dfd21f0f05cd2"
    sha256 cellar: :any_skip_relocation, ventura:       "01011f228e4eee6a204848b92e7e148143020695407919e6137dfd21f0f05cd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18befc0d468df5072a1cacd64d34e0a8ec2ab515e3c7303712d50819538af840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18befc0d468df5072a1cacd64d34e0a8ec2ab515e3c7303712d50819538af840"
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
