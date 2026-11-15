class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/refs/tags/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 22
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "34eb99ef62534d8959ddee800747b4054f8c309b74f308c4f5392348b70b02f4"
    sha256 cellar: :any, arm64_tahoe:       "b6f8dcf3a802c7a363ab2baf2f266bd82a0f42e746761ee80bf28240af102097"
    sha256 cellar: :any, arm64_sequoia:     "1640c525530ee781d02d2c390e75c2860b9bc6e8e46369d297454c3218679eb7"
    sha256 cellar: :any, arm64_linux:       "6c16341e64e6f183ea9f4400003366858e0db45b5173e90f1ad9a104f58fc58b"
    sha256 cellar: :any, x86_64_linux:      "738255c58d06c961675b647440bdee4ced5a4844dd197eedba3c8203ac4ea58a"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c@79"
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
    type :unofficial
    resolves "https://github.com/apngasm/apngasm/pull/111"
  end

  deny_network_access!

  def install
    inreplace "cli/CMakeLists.txt", "${CMAKE_INSTALL_PREFIX}/man/man1",
                                    "${CMAKE_INSTALL_PREFIX}/share/man/man1"
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
