class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/halide/Halide/archive/v15.0.0.tar.gz"
  sha256 "6680424f80c5731a85d977c06327096afe5af31da3667e91d4d36a25fabdda15"
  license "MIT"
  revision 1
  head "https://github.com/halide/Halide.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5418ebb54c3e5fd21001c62bcda25761aa6a255b2a5895bd9d6ee938e8edd470"
    sha256 cellar: :any,                 arm64_monterey: "da5a25b23985f950c227550332d0d81f7a2ce3b34a4c441cbc392d3398017558"
    sha256 cellar: :any,                 arm64_big_sur:  "4e5b7cf4af45fa0ba62dce53a0e4a718073be28e1eab990160a09c3c069e7ad3"
    sha256 cellar: :any,                 ventura:        "e2da1ac7dc825b27253c0985a99cafa0d452511eeed3656f805e3d67fea99a4e"
    sha256 cellar: :any,                 monterey:       "dcf6d60dcc69ec115420f0120607bb430330e17ef98a431d7389c4f6241cb03c"
    sha256 cellar: :any,                 big_sur:        "f8ff5065bf64c9816a4f969a5736b41469350dc9ae08ccb3003f08d0a2c51139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93ccf10fa2f5e3b21006449447374b5b19bc8bed1a5c7070edabc69ad1ef0a53"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "llvm@15"
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
