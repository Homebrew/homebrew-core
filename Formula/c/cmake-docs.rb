class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.30.5/cmake-3.30.5.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.30.5.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.30.5.tar.gz"
  sha256 "9f55e1a40508f2f29b7e065fa08c29f82c402fa0402da839fffe64a25755a86d"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d7f2006b814dbea90e2f83b0ab664823fde47d031fdda74668390fb9c1d276a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d7f2006b814dbea90e2f83b0ab664823fde47d031fdda74668390fb9c1d276a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d7f2006b814dbea90e2f83b0ab664823fde47d031fdda74668390fb9c1d276a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a1f6d4f052f691b996cbe677b11feb2596527efe73237669c802b27a0906691"
    sha256 cellar: :any_skip_relocation, ventura:       "9a1f6d4f052f691b996cbe677b11feb2596527efe73237669c802b27a0906691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d7f2006b814dbea90e2f83b0ab664823fde47d031fdda74668390fb9c1d276a"
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
