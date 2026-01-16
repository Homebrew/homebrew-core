class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/refs/tags/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 20
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:   "06ad2cd58116c3c62a72870f7f1ef0a1b4116285eab42c085648dfac4926ffd4"
    sha256                               arm64_sequoia: "7b80dcefcd186511ed93a327f44a794b779acb9ec5b7da9fe8100658dec1c2e3"
    sha256                               arm64_sonoma:  "7d1cf69a6e05eedccc87ef7f878bce2d8d4f531607efa9565fc8fe27412d549a"
    sha256                               sonoma:        "d0901f24ae3b9ea5d17ca77a012c05b2d2aa2ef546a63eb5fe6d42e5985ea596"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19251d12f2388fde4d495dbfcbe72b3883ee24fabbf38dc0f077981636897ad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11ae3807509bd5b7522d7fa850b52eff4b00b60ada10940fe16c5ab995d3ecec"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c@78"
  depends_on "libpng"
  depends_on "lzlib"

  uses_from_macos "zlib"

  fails_with :gcc do
    version "7"
    cause "Requires C++17 filesystem"
  end

  # Fix build with Boost 1.89.0, pr ref: https://github.com/apngasm/apngasm/pull/111
  patch do
    url "https://github.com/apngasm/apngasm/commit/7bf77bdefd348c629f650e2a5102a26ab6bee7b8.patch?full_index=1"
    sha256 "cbb9d679c5d46424bb00962481903f12b8b0e943dfdc98910ad05af7c7dacf5b"
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
    system bin/"apngasm", pkgshare/"test/samples/clock*.png"
  end
end
