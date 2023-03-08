class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.25.3/cmake-3.25.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.25.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.25.3.tar.gz"
  sha256 "cc995701d590ca6debc4245e9989939099ca52827dd46b5d3592f093afe1901c"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74d9f709432a7284de63acee52361e70433283f970751f49419f9f3a279bb019"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74d9f709432a7284de63acee52361e70433283f970751f49419f9f3a279bb019"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74d9f709432a7284de63acee52361e70433283f970751f49419f9f3a279bb019"
    sha256 cellar: :any_skip_relocation, ventura:        "da40295e21677af6dd8da00a7cb61dcbeadae9570dbc5445ab4144dbdab9b29a"
    sha256 cellar: :any_skip_relocation, monterey:       "da40295e21677af6dd8da00a7cb61dcbeadae9570dbc5445ab4144dbdab9b29a"
    sha256 cellar: :any_skip_relocation, big_sur:        "da40295e21677af6dd8da00a7cb61dcbeadae9570dbc5445ab4144dbdab9b29a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74d9f709432a7284de63acee52361e70433283f970751f49419f9f3a279bb019"
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
