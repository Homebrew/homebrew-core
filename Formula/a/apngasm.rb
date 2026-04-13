class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/refs/tags/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 20
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "f648a9450c38c86f0a2790b194a3f44534dbf8eb4cdca060ed4ba011aaf106dd"
    sha256                               arm64_sequoia: "48cff36bc137fc8a4369555a5fe2741830c12cf7d7ab4cb6719e5235806d352d"
    sha256                               arm64_sonoma:  "0e34041c1528674faf22b6dbf0270cae0ec788391b2ca39d5e68eeaac80a8130"
    sha256                               sonoma:        "d0cab8f5fe072f029bde277f83e27f77ff135e261eb37f7af74d9cd3dc531b9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7020b0940d9cf23dbd77afd912001b9d759d4b26722fecc4e1d482d54a8df890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fd1796b7defa25851257aa4245f02d0b3e31f23c9bf88440c1a3ee910e1ef66"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c@78"
  depends_on "libpng"
  depends_on "lzlib"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
