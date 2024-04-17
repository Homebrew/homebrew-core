class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.29.2/cmake-3.29.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.29.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.29.2.tar.gz"
  sha256 "36db4b6926aab741ba6e4b2ea2d99c9193222132308b4dc824d4123cb730352e"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d72edb6f2e966984524bc6e0e4175f8a73a5f9c28425881f21e75345e38e8520"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d72edb6f2e966984524bc6e0e4175f8a73a5f9c28425881f21e75345e38e8520"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d72edb6f2e966984524bc6e0e4175f8a73a5f9c28425881f21e75345e38e8520"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb088645af23269a10909ee511d4af575c13d73828fc4e68f5b9f0df989eb8cd"
    sha256 cellar: :any_skip_relocation, ventura:        "cb088645af23269a10909ee511d4af575c13d73828fc4e68f5b9f0df989eb8cd"
    sha256 cellar: :any_skip_relocation, monterey:       "cb088645af23269a10909ee511d4af575c13d73828fc4e68f5b9f0df989eb8cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d72edb6f2e966984524bc6e0e4175f8a73a5f9c28425881f21e75345e38e8520"
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
