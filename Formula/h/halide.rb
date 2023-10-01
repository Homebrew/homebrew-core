class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/halide/Halide/archive/v16.0.0.tar.gz"
  sha256 "a0cccee762681ea697124b8172dd65595856d0fa5bd4d1af7933046b4a085b04"
  license "MIT"
  revision 1
  head "https://github.com/halide/Halide.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "564ce04ffc10ea2dcf23de77a0dfb890253057dd614fb04dc2dac5f8f2a5718b"
    sha256 cellar: :any,                 arm64_monterey: "8f61d981dab71e927088763f5427d28b4b9503310455c4ee92e1187a79d89559"
    sha256 cellar: :any,                 arm64_big_sur:  "e706b543dc1d61cbff0b8286b6f0f22f1cbedb78204f13207c52a7eb6ff62dc9"
    sha256 cellar: :any,                 sonoma:         "d4372304d18e7e6afa9a75fca0646f3ae6c0288c1e234cce6372781eb531016c"
    sha256 cellar: :any,                 ventura:        "28f28c0c0e1b17a5e8c40408684640c0bd0abec51cd1edf440dc781648cf5615"
    sha256 cellar: :any,                 monterey:       "8c548b1ee5e6ae66f608a6240464a2e4fd356b407a7c34b4dbe1f5d9debc708f"
    sha256 cellar: :any,                 big_sur:        "0694de37e861f05d512be47de93f33d984d5c8e46af492677c24662f87f6c5b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4f02a55949ce8dc4ffcb50ed588633e729bd66521c09f0634a3be0c538fbcab"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "llvm@16"
  depends_on "python@3.11"

  fails_with :gcc do
    version "6"
    cause "Requires C++17"
  end

  def python3
    "python3.11"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DHalide_INSTALL_PYTHONDIR=#{prefix/Language::Python.site_packages(python3)}",
                    "-DHalide_SHARED_LLVM=ON",
                    "-DPYBIND11_USE_FETCHCONTENT=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp share/"doc/Halide/tutorial/lesson_01_basics.cpp", testpath
    system ENV.cxx, "-std=c++17", "lesson_01_basics.cpp", "-L#{lib}", "-lHalide", "-o", "test"
    assert_match "Success!", shell_output("./test")

    cp share/"doc/Halide_Python/tutorial-python/lesson_01_basics.py", testpath
    assert_match "Success!", shell_output("#{python3} lesson_01_basics.py")
  end
end
