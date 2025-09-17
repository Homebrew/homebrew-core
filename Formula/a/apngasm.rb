class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/refs/tags/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 18
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:   "8d4cb366969b69d558489a3225602608880d1618caa18f597b2ee57997affcb9"
    sha256                               arm64_sequoia: "909813b7286d5c3dbff8d6b13497fe607037fc65fe0ea065b676e2b831789073"
    sha256                               arm64_sonoma:  "e0d5bf50c94003d87095dcdd397ede2dcff470f208dfd60a63a49f2a5713490f"
    sha256                               arm64_ventura: "1eaf62b76489a8137ce94807e4620bb9858aa5fe14c2aae549ee21225549a6c8"
    sha256                               sonoma:        "f58b86508e14f1eec53218dab0e9ca5f4416fe48884f2be2439224f4763ec7bd"
    sha256                               ventura:       "9db2561881222680a4b2740f342ce45ec1ada0c4c95a211ad0bdb16c274fbc24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7799fbab3ad13774e371173cdf0c16d09506fa5e4bac755dd29d513e2d4be41e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab4cf496aea65ea1db6d5e1ac594e76e5f6e82454d8bc3e48fe03672d115bf3d"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c@77"
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
