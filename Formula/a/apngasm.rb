class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 7
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3f9da6cc06a428bf332a05d0e37f24b8ef58d3367d387f3d0e0b055a88865cc8"
    sha256 cellar: :any,                 arm64_monterey: "5da7148c96b13c85f4ff8cdb1b3f3a309be19b0a07ebb5711eaa7d2037158d19"
    sha256 cellar: :any,                 arm64_big_sur:  "38878c113cd01abe132818b6e50b48382c221390c5aca0d118d35a4f49c58066"
    sha256 cellar: :any,                 ventura:        "7c0293ed4c217e252bb34875f4ae70d0bfdfa139a1b52ff2668140358d39c54f"
    sha256 cellar: :any,                 monterey:       "10b52f74ab62f801c62f1b78614eba2e4e21f080eee53c3aea2e9c9718d24a62"
    sha256 cellar: :any,                 big_sur:        "e5becfcec0027d6cd8752e4d8382040877d34fa36099dbd558e554801029fced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0315fdfade74e9d14cffb22a4f2fd7d8647cda3b2c4b32058de119db301f75ba"
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
