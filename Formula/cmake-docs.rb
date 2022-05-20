class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.23.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.23.1.tar.gz"
  sha256 "33fd10a8ec687a4d0d5b42473f10459bb92b3ae7def2b745dc10b192760869f3"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c059eac37b2f074c1280791697e9433ff50120626ebc9ea327a250020967a6c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c059eac37b2f074c1280791697e9433ff50120626ebc9ea327a250020967a6c6"
    sha256 cellar: :any_skip_relocation, monterey:       "240eba24648b69bf6007a4bac5ca9ce577280d0135a414460be05f335181b147"
    sha256 cellar: :any_skip_relocation, big_sur:        "240eba24648b69bf6007a4bac5ca9ce577280d0135a414460be05f335181b147"
    sha256 cellar: :any_skip_relocation, catalina:       "240eba24648b69bf6007a4bac5ca9ce577280d0135a414460be05f335181b147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c059eac37b2f074c1280791697e9433ff50120626ebc9ea327a250020967a6c6"
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
