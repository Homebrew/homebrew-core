class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.4.4/cmake-4.4.4.tar.gz"
  sha256 "bd24c30d80a7744ae84b845ff080cc8453b06c622ef01066564108e9cefc44cf"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eea27ef1d3c92eab5399c157399fd64184ea3498ff1cff25501d50f0d852a36b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eea27ef1d3c92eab5399c157399fd64184ea3498ff1cff25501d50f0d852a36b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eea27ef1d3c92eab5399c157399fd64184ea3498ff1cff25501d50f0d852a36b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dfe8784f27d019dc56b04adce100911c6b5807e327debb44ede0467eec2bc87b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "dfe8784f27d019dc56b04adce100911c6b5807e327debb44ede0467eec2bc87b"
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build

  deny_network_access!

  def install
    args = %w[
      -DCMAKE_DOC_DIR=share/doc/cmake
      -DCMAKE_MAN_DIR=share/man
      -DSPHINX_MAN=ON
      -DSPHINX_HTML=ON
    ]
    system "cmake", "-S", "Utilities/Sphinx", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_path_exists share/"doc/cmake/html"
    assert_path_exists man
  end
end
