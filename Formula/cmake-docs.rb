class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.26.1/cmake-3.26.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.26.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.26.1.tar.gz"
  sha256 "f29964290ad3ced782a1e58ca9fda394a82406a647e24d6afd4e6c32e42c412f"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b203deb0d479a4298b61d90ba42cef00b5675d4b286af7929e8627343d0f907"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b203deb0d479a4298b61d90ba42cef00b5675d4b286af7929e8627343d0f907"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b203deb0d479a4298b61d90ba42cef00b5675d4b286af7929e8627343d0f907"
    sha256 cellar: :any_skip_relocation, ventura:        "5fa7e1906902e8b609a7e087b8a2f0bcfbb47884e0dcfa5258f0a27450942c69"
    sha256 cellar: :any_skip_relocation, monterey:       "5fa7e1906902e8b609a7e087b8a2f0bcfbb47884e0dcfa5258f0a27450942c69"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fa7e1906902e8b609a7e087b8a2f0bcfbb47884e0dcfa5258f0a27450942c69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b203deb0d479a4298b61d90ba42cef00b5675d4b286af7929e8627343d0f907"
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
