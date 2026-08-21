class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/refs/tags/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 21
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "966855f1ea8c56efffe2742f7996faa2c1b0165cb67e8f5ada333858f0826cd0"
    sha256               arm64_sequoia: "eb6d9b9fa2220ccd5124c488aff53476c7e407403ca2d9ab24cb0685ee6fa5ce"
    sha256               arm64_sonoma:  "2e951e2aa77f5a23621a3f12b66a9394fdd1fde91f95085242258f3ede4f404e"
    sha256               sonoma:        "94c80c1c85c7592e702d956dce574d59b0f7b77753ae6686d7df4656b1ba59cd"
    sha256 cellar: :any, arm64_linux:   "c9bc56b58aaf0e09148c4461c6ee33d1d13fb764ac8faf79174793ae5c5d5cca"
    sha256 cellar: :any, x86_64_linux:  "2b906b77e7a3188025b4a789768943305f6c17d30e79f16bd56d5a5804b78a12"
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
    type :unofficial
    resolves "https://github.com/apngasm/apngasm/pull/111"
  end

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
