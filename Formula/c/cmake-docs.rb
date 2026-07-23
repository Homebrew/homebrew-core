class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.4.0/cmake-4.4.0.tar.gz"
  sha256 "65757f442fdd242e27f1728fc26dc0cba4164f7a0791a5c788631c00080369bc"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "934fad083f74d397b8038863157e6edc1c32bc5ce5eddc24124bd544a172c933"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "934fad083f74d397b8038863157e6edc1c32bc5ce5eddc24124bd544a172c933"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "934fad083f74d397b8038863157e6edc1c32bc5ce5eddc24124bd544a172c933"
    sha256 cellar: :any_skip_relocation, sonoma:        "934fad083f74d397b8038863157e6edc1c32bc5ce5eddc24124bd544a172c933"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2eaaa74b5d7c7eba529396cf02633946601607435b5904062bad200db267a498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2eaaa74b5d7c7eba529396cf02633946601607435b5904062bad200db267a498"
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
