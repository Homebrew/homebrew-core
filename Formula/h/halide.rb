class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/refs/tags/v17.0.1.tar.gz"
  sha256 "beb18331d9e4b6f69943bcc75fb9d923a250ae689f09f6940a01636243289727"
  license "MIT"
  revision 1
  head "https://github.com/halide/Halide.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fabb3fb758e0da8961127fd87d60521a8188ecb5d0c324a87e16b6421a2ee8ba"
    sha256 cellar: :any,                 arm64_ventura:  "556f60f7f86267903ade80791a9b308aa3645692c1b37990cdc4f8c99129568d"
    sha256 cellar: :any,                 arm64_monterey: "e50fda2ef326f399bc16694dc444657f6fa2c3c3062d7fc2c3ae7250f6d1098f"
    sha256 cellar: :any,                 sonoma:         "13409066855f0e41f5f01a1527697ccd35b691b52c0790463049a4248cadbec8"
    sha256 cellar: :any,                 ventura:        "f82ea6355cdfb1833c20383a90c22493dc35e5bdb526ed954bfed6be20d54923"
    sha256 cellar: :any,                 monterey:       "89a9af672d492aa15934bfb0bddf04a92ae914d0de6df3d3dc9beea2bd58023b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e78fdb7bbee95088361735d04a15205c448a8cd1f24278f6f4d0870c2e1eaec9"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "llvm@17"
  depends_on "python@3.12"

  fails_with :gcc do
    version "6"
    cause "Requires C++17"
  end

  def python3
    "python3.12"
  end

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm@17"].opt_lib if DevelopmentTools.clang_build_version >= 1500

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
