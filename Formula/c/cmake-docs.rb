class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.27.4/cmake-3.27.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.27.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.27.4.tar.gz"
  sha256 "0a905ca8635ca81aa152e123bdde7e54cbe764fdd9a70d62af44cad8b92967af"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "434404dfb4e4a08e31d4237284fea1dfd82d81d02fd460ddabf79711ffa868af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "434404dfb4e4a08e31d4237284fea1dfd82d81d02fd460ddabf79711ffa868af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "434404dfb4e4a08e31d4237284fea1dfd82d81d02fd460ddabf79711ffa868af"
    sha256 cellar: :any_skip_relocation, ventura:        "db5aece5629fc1adba29952fdb8cb5f38467744933827faefb2b1f7c4bd94cba"
    sha256 cellar: :any_skip_relocation, monterey:       "db5aece5629fc1adba29952fdb8cb5f38467744933827faefb2b1f7c4bd94cba"
    sha256 cellar: :any_skip_relocation, big_sur:        "db5aece5629fc1adba29952fdb8cb5f38467744933827faefb2b1f7c4bd94cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "434404dfb4e4a08e31d4237284fea1dfd82d81d02fd460ddabf79711ffa868af"
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
