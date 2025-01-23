class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.4/cmake-3.31.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.31.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.31.4.tar.gz"
  sha256 "a6130bfe75f5ba5c73e672e34359f7c0a1931521957e8393a5c2922c8b0f7f25"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edac0c3b67e6f6649bdee9bf91bd653098ddb30a140852a5e9a25244a5425a32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edac0c3b67e6f6649bdee9bf91bd653098ddb30a140852a5e9a25244a5425a32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "edac0c3b67e6f6649bdee9bf91bd653098ddb30a140852a5e9a25244a5425a32"
    sha256 cellar: :any_skip_relocation, sonoma:        "50c2b8091d5824086622632f43f29b58ac5bb3b497de008d65274f6c15038f52"
    sha256 cellar: :any_skip_relocation, ventura:       "50c2b8091d5824086622632f43f29b58ac5bb3b497de008d65274f6c15038f52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edac0c3b67e6f6649bdee9bf91bd653098ddb30a140852a5e9a25244a5425a32"
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
