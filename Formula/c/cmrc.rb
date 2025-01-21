class Cmrc < Formula
  desc "CMake Resource Compiler"
  homepage "https://github.com/vector-of-bool/cmrc"
  url "https://github.com/vector-of-bool/cmrc/archive/refs/tags/2.0.1.tar.gz"
  sha256 "edad5faaa0bea1df124b5e8cb00bf0adbd2faeccecd3b5c146796cbcb8b5b71b"
  license "MIT"
  head "https://github.com/vector-of-bool/cmrc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "33e1b8facfc9147d12e16f1ea45cb08c26f6e4d9ee5100b298f76a0f01a475ae"
  end

  depends_on "cmake" => [:build, :test]

  def install
    (share/"cmake").install "CMakeRC.cmake"
    (share/"CMakeRC/cmake").install_symlink share/"cmake/CMakeRC.cmake" => "CMakeRCConfig.cmake"
  end

  test do
    cmakelists = testpath/"CMakeLists.txt"
    cmakelists.write <<~CMAKE
      cmake_minimum_required(VERSION 3.30)
      include(CMakeRC)
    CMAKE
    system "cmake", "-S", ".", "-B", "build1", "-DCMAKE_MODULE_PATH=#{share}/cmake", *std_cmake_args

    cmakelists.unlink
    cmakelists.write <<~CMAKE
      cmake_minimum_required(VERSION 3.30)
      find_package(CMakeRC CONFIG REQUIRED)
    CMAKE

    system "cmake", "-S", ".", "-B", "build2", *std_cmake_args
  end
end
