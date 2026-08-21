class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.4.2/cmake-4.4.2.tar.gz"
  sha256 "1db9e61e60b6e0874c86386340b910382f3c5e75b9fbfb44d122063129a2789d"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79937ad95c5bcfe73795e8b86f91369da76a12c7b8ac24a0935edd864fd30226"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79937ad95c5bcfe73795e8b86f91369da76a12c7b8ac24a0935edd864fd30226"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79937ad95c5bcfe73795e8b86f91369da76a12c7b8ac24a0935edd864fd30226"
    sha256 cellar: :any_skip_relocation, sonoma:        "79937ad95c5bcfe73795e8b86f91369da76a12c7b8ac24a0935edd864fd30226"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ccfe0385655651d7252f008b356ba61e5acb260eb671fc2396cf947b2a48d84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ccfe0385655651d7252f008b356ba61e5acb260eb671fc2396cf947b2a48d84"
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
