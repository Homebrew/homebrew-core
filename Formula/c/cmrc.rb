class Cmrc < Formula
  desc "CMake Resource Compiler"
  homepage "https://github.com/vector-of-bool/cmrc"
  license "MIT"
  head "https://github.com/vector-of-bool/cmrc.git", branch: "master"

  stable do
    url "https://github.com/vector-of-bool/cmrc/archive/refs/tags/2.0.1.tar.gz"
    sha256 "edad5faaa0bea1df124b5e8cb00bf0adbd2faeccecd3b5c146796cbcb8b5b71b"

    # cmake 4.0 build patch, upstream pr ref, https://github.com/vector-of-bool/cmrc/pull/48
    patch do
      url "https://github.com/vector-of-bool/cmrc/commit/91c9522ee59654e2f4d9701947a4600a4436d076.patch?full_index=1"
      sha256 "feea3f04cdf49295497f3c48dd3ad5938716e47a9b29aacc98dc6580493d74ff"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "bccb869a3fb9486fbd2594d68a8be7fb57819f27764bbf9b3888cdc54d746ce7"
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
      cmake_minimum_required(VERSION 4.0)
      find_package(CMakeRC CONFIG REQUIRED)
    CMAKE

    system "cmake", "-S", ".", "-B", "build2", *std_cmake_args
  end
end
