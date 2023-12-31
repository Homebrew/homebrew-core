class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.28.1/cmake-3.28.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.28.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.28.1.tar.gz"
  sha256 "15e94f83e647f7d620a140a7a5da76349fc47a1bfed66d0f5cdee8e7344079ad"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a382301202621a32a2ade754ac11270ca949788e792309b107545fc5d65ec01c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a382301202621a32a2ade754ac11270ca949788e792309b107545fc5d65ec01c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a382301202621a32a2ade754ac11270ca949788e792309b107545fc5d65ec01c"
    sha256 cellar: :any_skip_relocation, sonoma:         "61e449dc15ab93491ce0c3f7826196fa33aea3515d80fd07606d7235c0e7eb30"
    sha256 cellar: :any_skip_relocation, ventura:        "61e449dc15ab93491ce0c3f7826196fa33aea3515d80fd07606d7235c0e7eb30"
    sha256 cellar: :any_skip_relocation, monterey:       "61e449dc15ab93491ce0c3f7826196fa33aea3515d80fd07606d7235c0e7eb30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a382301202621a32a2ade754ac11270ca949788e792309b107545fc5d65ec01c"
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
