class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/halide/Halide/archive/v15.0.1.tar.gz"
  sha256 "0bc440df8d7b4e09bf73636371573701dee6ba3d5df9334df1048ea2dd34c788"
  license "MIT"
  head "https://github.com/halide/Halide.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2a0574fc23f4e798aff3efb68b732acd087a422479f7b14a78474ddae4c6bd0c"
    sha256 cellar: :any,                 arm64_monterey: "3ef776c45f877bd3364c9ef60d024e5d323b70b417eee50a26dfb57e87c9687b"
    sha256 cellar: :any,                 arm64_big_sur:  "53fbd263dbfb79a699b2b24b2cf2203923e96f4a35d25bdc354be0d05c6c60da"
    sha256 cellar: :any,                 ventura:        "bdb836ae39cf5a333e9a7170be1b9448de207275316be65c5cd90eedd0e49127"
    sha256 cellar: :any,                 monterey:       "32aed6e417e9bb15f56bdcb16125eae6fc07d1bd0d7434ab5522df37c0857447"
    sha256 cellar: :any,                 big_sur:        "a6781014b6f6209a3d3f91b85b9a6e04c6264cd5a01b80f7c7c5125ed63b0abb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74a2b94973ea91eda308ef9560bc5839d59fb1ce03d11becc92f0fd08fe4e649"
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
