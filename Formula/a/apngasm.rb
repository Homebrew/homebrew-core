class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/refs/tags/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 15
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "9ab6d41b1207fda23093f453b7a01dd53de9ed4ce3afceba84e04d285bc24b86"
    sha256                               arm64_sonoma:  "34179cfc45bd2d0de38857a16074e94eb377f7fbd0da8bd7bb71f94c0c4ed943"
    sha256                               arm64_ventura: "0633ef0217bfae8ff34422403729eb063321bc7264847ea2d6e25d1b9bf06436"
    sha256                               sonoma:        "83e5b9b112bb3bfbc35b42e764738a652bdf6ac715c03d9e2a049930d9518fe5"
    sha256                               ventura:       "18facc88d2285faeea0dc9bd2d3fcb75744fdaccbc2c14b4c8404a6dda00313b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "786c541183a6c3e45bbf3bb74141bc0570bb664dbf3e20ce71f6e7f2674c0166"
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
