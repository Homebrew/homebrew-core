class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.4.3/cmake-4.4.3.tar.gz"
  sha256 "c46400618b4f1f2b43507f24fb22f3ae830c3416cf23b776e16e1d413aa892f0"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "10d31af938ee19c2dbb36723891df786854861d82cb3b610d05f9b02527d9f96"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "10d31af938ee19c2dbb36723891df786854861d82cb3b610d05f9b02527d9f96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "10d31af938ee19c2dbb36723891df786854861d82cb3b610d05f9b02527d9f96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "10d31af938ee19c2dbb36723891df786854861d82cb3b610d05f9b02527d9f96"
    sha256 cellar: :any_skip_relocation, sonoma:            "10d31af938ee19c2dbb36723891df786854861d82cb3b610d05f9b02527d9f96"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a8f7a63b3cee5dca8a52d6c91373d0777beec8b2ce1747e04a4cba58e17fc1ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a8f7a63b3cee5dca8a52d6c91373d0777beec8b2ce1747e04a4cba58e17fc1ff"
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build

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
