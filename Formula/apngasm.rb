class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 1
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 cellar: :any,                 arm64_monterey: "80b90951415a88eff1da221b4826a2f1511fa5322ba04c449f3aeec393e0999b"
    sha256 cellar: :any,                 arm64_big_sur:  "d4bbbe2f3dce2bf221ee011f7f192ca1b5c2e1440214bc0105d09a0c0be356bd"
    sha256 cellar: :any,                 monterey:       "2cfe286cfa16d59d200bb5b1b5f37afa66d01e270c976cc179f82dc70e6e1fe5"
    sha256 cellar: :any,                 big_sur:        "4b7399bdb7991330dee6a26a00ee1ec58e6074895b026fda608950b0372525d7"
    sha256 cellar: :any,                 catalina:       "bcba805553ae564c117609755b2f4c3e06f1c23579430505fa89fda8c126c06c"
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
