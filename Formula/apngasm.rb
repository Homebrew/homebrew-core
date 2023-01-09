class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 4
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b9db6c9adac39b6b1e4afe511472635ed361ef2fbae6fcc0694283fb1dddf630"
    sha256 cellar: :any,                 arm64_monterey: "fd9e195a8b24a53bef5d7dcfe9470d8f494eda43bbaaa44b36eb24c42e1d3959"
    sha256 cellar: :any,                 arm64_big_sur:  "0b5fd726639d86fa4008fd4d3fb29f1313d7d8d4d6a5c2820fd354e147156fa0"
    sha256 cellar: :any,                 ventura:        "b63e551bfaaddaadb792b454ddde69e693bed2bd4435bdedaff7b66e9bb73d5d"
    sha256 cellar: :any,                 monterey:       "17a6c164d5fb808335ec25998621638c7ef3aa714a326e9b6926dde893a630ff"
    sha256 cellar: :any,                 big_sur:        "0111443fb6f01ecbbc8eb12b2bd1c8912b2b9dc5378838ee21ea6f7b72659fa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eda65cdfab5b3a8f30d2630216ea72dbce9938f03f973d37d5104faadceeb065"
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
