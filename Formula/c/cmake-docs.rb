class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.0.0/cmake-4.0.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.0.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.0.0.tar.gz"
  sha256 "ddc54ad63b87e153cf50be450a6580f1b17b4881de8941da963ff56991a4083b"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a894fcab9dc2fb9ebddcc116c53d069ad202a44fdc6017f2a4271f398ff9c651"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a894fcab9dc2fb9ebddcc116c53d069ad202a44fdc6017f2a4271f398ff9c651"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a894fcab9dc2fb9ebddcc116c53d069ad202a44fdc6017f2a4271f398ff9c651"
    sha256 cellar: :any_skip_relocation, sonoma:        "5688bd834d37c604800accda35ac9b9764be0e24e5be40dbd3978b9fda2aa539"
    sha256 cellar: :any_skip_relocation, ventura:       "5688bd834d37c604800accda35ac9b9764be0e24e5be40dbd3978b9fda2aa539"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e627cac3820a7465f45865349ec0a031c044c7d28d87a60833e240d629c87d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a894fcab9dc2fb9ebddcc116c53d069ad202a44fdc6017f2a4271f398ff9c651"
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
