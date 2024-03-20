class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.28.4/cmake-3.28.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.28.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.28.4.tar.gz"
  sha256 "eb9c787e078848dc493f4f83f8a4bbec857cd1f38ab6425ce8d2776a9f6aa6fb"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9fcd2aaa54fa8ba1d0d6451b6185f1716bc5bbe2c3609a441ce766aa4224c54b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fcd2aaa54fa8ba1d0d6451b6185f1716bc5bbe2c3609a441ce766aa4224c54b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fcd2aaa54fa8ba1d0d6451b6185f1716bc5bbe2c3609a441ce766aa4224c54b"
    sha256 cellar: :any_skip_relocation, sonoma:         "894cd23426787eb7bdaedbe8bfebde3199efa659b1bb6dd192772aa141a53842"
    sha256 cellar: :any_skip_relocation, ventura:        "894cd23426787eb7bdaedbe8bfebde3199efa659b1bb6dd192772aa141a53842"
    sha256 cellar: :any_skip_relocation, monterey:       "894cd23426787eb7bdaedbe8bfebde3199efa659b1bb6dd192772aa141a53842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fcd2aaa54fa8ba1d0d6451b6185f1716bc5bbe2c3609a441ce766aa4224c54b"
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
