class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.26.3/cmake-3.26.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.26.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.26.3.tar.gz"
  sha256 "bbd8d39217509d163cb544a40d6428ac666ddc83e22905d3e52c925781f0f659"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d272e1336a84068c9e00799d67a2f3baecfbc884ed15dc76f97fc5f6720fe822"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d272e1336a84068c9e00799d67a2f3baecfbc884ed15dc76f97fc5f6720fe822"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d272e1336a84068c9e00799d67a2f3baecfbc884ed15dc76f97fc5f6720fe822"
    sha256 cellar: :any_skip_relocation, ventura:        "09e3a1a3722dc65a47de4a96d13092ed83bb0fab075e1cbed30680619a7603e8"
    sha256 cellar: :any_skip_relocation, monterey:       "09e3a1a3722dc65a47de4a96d13092ed83bb0fab075e1cbed30680619a7603e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "09e3a1a3722dc65a47de4a96d13092ed83bb0fab075e1cbed30680619a7603e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d272e1336a84068c9e00799d67a2f3baecfbc884ed15dc76f97fc5f6720fe822"
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
