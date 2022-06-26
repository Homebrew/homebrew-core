class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.23.2/cmake-3.23.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.23.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.23.2.tar.gz"
  sha256 "f316b40053466f9a416adf981efda41b160ca859e97f6a484b447ea299ff26aa"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e853d4cf6ecfaf41cf93c44ef42a2b5c568e3161c191012602d4e99b52947b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e853d4cf6ecfaf41cf93c44ef42a2b5c568e3161c191012602d4e99b52947b2"
    sha256 cellar: :any_skip_relocation, monterey:       "1c7fd482b60cb92d2b4874243c175d4f8627ef0e0d598cd2999cd53a9191f07d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c7fd482b60cb92d2b4874243c175d4f8627ef0e0d598cd2999cd53a9191f07d"
    sha256 cellar: :any_skip_relocation, catalina:       "1c7fd482b60cb92d2b4874243c175d4f8627ef0e0d598cd2999cd53a9191f07d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e853d4cf6ecfaf41cf93c44ef42a2b5c568e3161c191012602d4e99b52947b2"
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
