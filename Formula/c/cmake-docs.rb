class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.3/cmake-3.31.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.31.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.31.3.tar.gz"
  sha256 "fac45bc6d410b49b3113ab866074888d6c9e9dc81a141874446eb239ac38cb87"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ed3795024ac004c81550d39211b83d8d055201f3d8405c5670bf5512e8701d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ed3795024ac004c81550d39211b83d8d055201f3d8405c5670bf5512e8701d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ed3795024ac004c81550d39211b83d8d055201f3d8405c5670bf5512e8701d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6eada3160082c79fb320edf5214366d9cb4636a5f7d8f608caeb92256905a67"
    sha256 cellar: :any_skip_relocation, ventura:       "c6eada3160082c79fb320edf5214366d9cb4636a5f7d8f608caeb92256905a67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ed3795024ac004c81550d39211b83d8d055201f3d8405c5670bf5512e8701d1"
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
