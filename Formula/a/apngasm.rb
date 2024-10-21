class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/refs/tags/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 13
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "2d444cec3ef5d87bf413c3301e57694afffa0c1ec51d433263e2cc95d89b266b"
    sha256                               arm64_sonoma:  "5295b412245ce613f0d55fdd649ba21912882d48b3ec5ee7d1f7c3b3467be20b"
    sha256                               arm64_ventura: "52256178a1979d8f85508d7c272840791bafeca1ef4c4bc036dc38304500bb04"
    sha256                               sonoma:        "f687ee190ad2460ec32fb4a9792449c130b1d1317de72561f9fdc5068553eb5a"
    sha256                               ventura:       "394141501308f60470f4b3a6205b057cf067423da675d1283136020758aaa0f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9c0d5bea8288502309fc70b025fe030fb2067053242a0315afbe04b304988bf"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c@75"
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
