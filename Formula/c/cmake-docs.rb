class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.0.1/cmake-4.0.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.0.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.0.1.tar.gz"
  sha256 "d630a7e00e63e520b25259f83d425ef783b4661bdc8f47e21c7f23f3780a21e1"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66b1349b89aeb52601d5c36965f924da8544fecfc6a70e770096af7ee60340da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66b1349b89aeb52601d5c36965f924da8544fecfc6a70e770096af7ee60340da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66b1349b89aeb52601d5c36965f924da8544fecfc6a70e770096af7ee60340da"
    sha256 cellar: :any_skip_relocation, sonoma:        "fecfbce50b262f54bf77fa00c957dde6a4d68d24241b14e7263b7ef575bcedfd"
    sha256 cellar: :any_skip_relocation, ventura:       "fecfbce50b262f54bf77fa00c957dde6a4d68d24241b14e7263b7ef575bcedfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66b1349b89aeb52601d5c36965f924da8544fecfc6a70e770096af7ee60340da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66b1349b89aeb52601d5c36965f924da8544fecfc6a70e770096af7ee60340da"
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
