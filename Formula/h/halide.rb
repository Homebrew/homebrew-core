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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "9c225bdb3cb4289b5bb121934519e09d08673d20edb675597fc98624612c5539"
    sha256 cellar: :any,                 arm64_monterey: "778bbca758d3945f263f9bc18781d4a54f49e3ab8dbc67e0913aa902b04972af"
    sha256 cellar: :any,                 sonoma:         "cfc7bf242ade7297dbd59128746629c3058f0078eb504f62513c52922124734e"
    sha256 cellar: :any,                 ventura:        "83b5ff39ff7172243c85d146faf5e8f689d5eb11d3d32e807417c867526559b1"
    sha256 cellar: :any,                 monterey:       "39caeadda09ef26ba1956eb243b65e42d8880090b7c2f1ad0133e02a3d5885bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "233c56cd195d0183d4d70fac3fa9f846fc5b5c53a37415758302958f1b07de0f"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "llvm@16"
  depends_on "python@3.12"

  fails_with :gcc do
    version "6"
    cause "Requires C++17"
  end

  def python3
    "python3.12"
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
