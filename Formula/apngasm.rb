class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 3
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c177663cbe53b8e95df7f58e4ae29d474ad6d6a783fa06759d29873a36c92a41"
    sha256 cellar: :any,                 arm64_big_sur:  "c292d029d6a70e1232f30423690b71be59baa2738bf2f025ac9e7d4c3513f734"
    sha256 cellar: :any,                 monterey:       "b2beca474fc168a54f16fabe8800ebb73fc3928409bb8dc04f6367bceb9909c4"
    sha256 cellar: :any,                 big_sur:        "41ad219c9048cca6c303833ec301f50924a0cafc190ef5425f93544f2d56fc13"
    sha256 cellar: :any,                 catalina:       "406db22f6432af40fd166975ac9050ad7d2152ea95cd62c4124c67e1eca1b76f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f3921b1583e8912557caa117dfe36ff7f63083d1969743373a11684768ba6b5"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "lzlib"
  depends_on macos: :catalina

  fails_with :gcc do
    version "7"
    cause "Requires C++17 filesystem"
  end

  def install
    inreplace "cli/CMakeLists.txt", "${CMAKE_INSTALL_PREFIX}/man/man1",
                                    "${CMAKE_INSTALL_PREFIX}/share/man/man1"
    ENV.cxx11
    ENV.deparallelize # Build error: ld: library not found for -lapngasm
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"test").install "test/samples"
  end

  test do
    system bin/"apngasm", "#{pkgshare}/test/samples/clock*.png"
  end
end
