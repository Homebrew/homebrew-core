class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.29.3/cmake-3.29.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.29.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.29.3.tar.gz"
  sha256 "252aee1448d49caa04954fd5e27d189dd51570557313e7b281636716a238bccb"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0cce7db3d630650b6d7e71c5cec1e61784fa523d5849954384310ca7ea1a8d8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd00f0963fad2d5a930c39e74ca716c0a4afe871ca10ef726b135e3f90f72d38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c938d5b48c18421b6dbf8447147318e966b8654aa3397621b4aa642080d1cda1"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bf6f5c6f06bc38b3963397c1da40e12b826fc8ca71e1cfdbf1631d63cdce215"
    sha256 cellar: :any_skip_relocation, ventura:        "e099a5de59eb9d68b9356071603c88bd26d759e9880f66cfccf232b728556e45"
    sha256 cellar: :any_skip_relocation, monterey:       "7fd6d139da343a0ff3116b7bf477403ff14f679c648fd43643ac568c09266558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57dc1b51197f12f88ad70e11f1f27bd52d89e0aeafad2a3e1a2d5a6d5e49b47e"
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
