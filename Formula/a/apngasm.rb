class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/refs/tags/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 8
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "1482f26eabdfedaa35741d0c281e315d863d4678fe3d92677653d2460694d36b"
    sha256 cellar: :any,                 arm64_ventura:  "1979f8768835588284eb04ff9a0cc2ceee1f755604bb6eba37d59ac2277203c1"
    sha256 cellar: :any,                 arm64_monterey: "caf5ddef45e3d6b18e541744456270d72a3d8f64fd3534a8cc4fa157c73b381a"
    sha256                               sonoma:         "7e27ca950dbed5132a0812b7a61b212ce73198d91486efc604065a42f316a792"
    sha256 cellar: :any,                 ventura:        "e0fac2cdb862f7eaef78d42cbd2d8d904f76568c54fd94583050b26761ad5fc4"
    sha256 cellar: :any,                 monterey:       "4b003e22148109be8518ed8029fa66b82428c903e6dbc21529ad3b2f7cb19d07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9eb5323e8383c2c02396dfc27a4a59dcf593dbc1102276b0a70352a3faea4f0"
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
