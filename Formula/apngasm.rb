class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 2
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "417ef627abddb455da5fda0eb6615b1c23fe0b0fe6f2920cffa6eb73f0a7930e"
    sha256 cellar: :any,                 arm64_big_sur:  "b20fcddf36955cc5233687bb2090f95877970501f63569c5b0cae6f743063373"
    sha256 cellar: :any,                 monterey:       "d44e728d2f8000e6e46ad8f231f047cc21da5be3f2734faf043fe54d92f24c2c"
    sha256 cellar: :any,                 big_sur:        "973092d55f2cdc1e30030c73c6f90b5ab5622f4c63e285233aaeff73f05fc690"
    sha256 cellar: :any,                 catalina:       "c576196db665297b539c284175b7fc76e04d7b2e71d64602e3d81259331e8193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5308106ba734492bd70672e601539937771e254ec43c0ca747fe30245d53a71"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "lzlib"
  depends_on macos: :catalina

  on_linux do
    depends_on "gcc"
  end

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
