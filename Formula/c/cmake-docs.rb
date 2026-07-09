class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.3.4/cmake-4.3.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.3.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.3.4.tar.gz"
  sha256 "fdeff897b9eb49d764539f2b1edc6eb7e1440df325678a97c1978499e931adda"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "860dfbea9444617959e3c4f4c09b2b69576e9291b5cace23c99be11ee3209e3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "860dfbea9444617959e3c4f4c09b2b69576e9291b5cace23c99be11ee3209e3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "860dfbea9444617959e3c4f4c09b2b69576e9291b5cace23c99be11ee3209e3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "860dfbea9444617959e3c4f4c09b2b69576e9291b5cace23c99be11ee3209e3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b22aa42a64c5975eaf070554ec02839dfb5191713cf41c7d6f02a73f19d97a5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b22aa42a64c5975eaf070554ec02839dfb5191713cf41c7d6f02a73f19d97a5d"
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
