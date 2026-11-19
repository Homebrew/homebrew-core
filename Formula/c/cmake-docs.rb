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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "94fa65df8bab4dc9dd0a549b31cdff0cb168c0a30046f43c5cd2fe6b5f7e907c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "94fa65df8bab4dc9dd0a549b31cdff0cb168c0a30046f43c5cd2fe6b5f7e907c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "94fa65df8bab4dc9dd0a549b31cdff0cb168c0a30046f43c5cd2fe6b5f7e907c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f9b7791e5831dc634b3a2b8afd046162f4d6bc417ccf627658efbaaab7062f45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f9b7791e5831dc634b3a2b8afd046162f4d6bc417ccf627658efbaaab7062f45"
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
