class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.5.1/cmake-4.5.1.tar.gz"
  sha256 "a79bf33cbe05686fdf79c2bbbcfe5e8e62ad16d3d540fa737cbedfeed41fb69e"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    manifest_sha256 "5b4fe280b00410740841d62fa6398e97ff513d1bef36358b09840067edf7108c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d69f13702cc8a42122c611747cc628a7afddab78ac3603ba0e444eb7416fa353"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d69f13702cc8a42122c611747cc628a7afddab78ac3603ba0e444eb7416fa353"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d69f13702cc8a42122c611747cc628a7afddab78ac3603ba0e444eb7416fa353"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e19544a58f149fa1a3933e05e7c8da67d82d7b3e59c6c47c9674a379f1aab451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e19544a58f149fa1a3933e05e7c8da67d82d7b3e59c6c47c9674a379f1aab451"
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
