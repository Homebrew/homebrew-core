class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "013957786451917bee554fc4a8e53a19163c15e76fa92623349e3fd75a0fdfe6"
    sha256 cellar: :any,                 arm64_big_sur:  "4ece563fa1571fa78e0481b8aa3237035d7424366eead22c2d32be9d5415b392"
    sha256 cellar: :any,                 monterey:       "fbe72e5a561b325803900a3ab33721b470e4fda5ddf1c1aa9330b925caf00c89"
    sha256 cellar: :any,                 big_sur:        "256488e04ed74850915b99697fece6fdd2d0f79cef0351b56096336537b4fff7"
    sha256 cellar: :any,                 catalina:       "08ce0311e991a31ab52c8b51dbc5cb0403f1e00ea652a6dbf1c8c535b8216a28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82dbded4f63ead5cc474a42793fc17edabc9455c54b5de2f748cf3a17706d529"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "lzlib"
  depends_on macos: :catalina

  on_linux do
    depends_on "gcc"
  end

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
