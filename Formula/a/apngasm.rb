class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/refs/tags/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 15
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "2b2d7f84cbf68412484f783c0c9330c32396dc958f4d3098b5137597e263e157"
    sha256                               arm64_sonoma:  "0f5236c52963cd65362f426d49aa3b6752d36318111c043fb70b9ae842c009ab"
    sha256                               arm64_ventura: "d5a4d1b71c16e7c2ce938d38844ffdd380009b9b23c17372036b69189cbc5a2e"
    sha256                               sonoma:        "94ef10b6288b9ffe5e3083934961c77e85fca72be581b09e3962069fdec8e8b2"
    sha256                               ventura:       "7bbdaf65dd1e61d6af0379672f5176977078be7d9ccfe7c15715a6e88a1cb83d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0684fdd07df4338094b2508e113543df71732648137c3de6960ea73bfb5db07d"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c@76"
  depends_on "libpng"
  depends_on "lzlib"
  depends_on macos: :catalina

  uses_from_macos "zlib"

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
    system bin/"apngasm", pkgshare/"test/samples/clock*.png"
  end
end
