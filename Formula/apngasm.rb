class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 5
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4acdb6cff6fa9d01338279fc4dac97218cb8aa028ed3863373d4e5209fb86ae7"
    sha256 cellar: :any,                 arm64_monterey: "68e7bfc9f0857f455da553dd6cd470c58ba27d7b9b583dffbf45d26b55615cc6"
    sha256 cellar: :any,                 arm64_big_sur:  "042c64d0af4c1ba61312ab78e6b605889890b0b71ea6e5826e1e8a24b63aaf78"
    sha256 cellar: :any,                 ventura:        "6dd843425e4346b0dfd4715609e7f5566ed614929eab0f040ca94badfe83e64f"
    sha256 cellar: :any,                 monterey:       "0680cc57600f7c28acd73c11a4563378876f89b8541cf8c3662fb04f27ea55c1"
    sha256 cellar: :any,                 big_sur:        "d7fe15f3a3c4f723b7c1ed5324eb300d75c5cfca0b7d8ab0e8e48af104c91cd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af638cd0b4172b7afbf389201171c25307405f5e6e93b50b22f249f68aa3d3e1"
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
