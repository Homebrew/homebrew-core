class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/refs/tags/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 11
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "2f61c6340c8eadc8729e454e17e3c314820337e8d6a4b4eb392c73c7eab39a7c"
    sha256                               arm64_ventura:  "a06bffb3cc491374aadf87a740be776cfc5253abaec77264f16b0bc9030f302f"
    sha256 cellar: :any,                 arm64_monterey: "3fdcddec740544d229616778d93538091cfb389785864afd78a5195e59aa22a2"
    sha256                               sonoma:         "1ec6f39883a8a215f919123e88167463e9849585f8e1efd9646e2445e5729c11"
    sha256                               ventura:        "f5780df1f954cda1f3faebb7638e3659f3ba7c8c5448d76787c8be50351cc273"
    sha256 cellar: :any,                 monterey:       "ec6d993ace19b67358e5634bdfddd41fe55f4e71399200d786d0c8488ef5241a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52eddc362b2b6e863fcdffbbc8957a7ad6ddfba61fd99be211f6caf269613332"
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
