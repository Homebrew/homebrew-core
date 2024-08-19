class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/refs/tags/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 12
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "3a6f6e9b91f2d80ce968c45c3afb0451571c8c36e8d77d0bd39a3019bb287a7b"
    sha256                               arm64_ventura:  "4e25dd800a4f2d03b45eacd18923a4f506e12ebd622f40320897e54010f55005"
    sha256 cellar: :any,                 arm64_monterey: "6e14826462b3dc0680497efedb6e07a1c5c7b7e654390bc0a4dd4717988ca795"
    sha256                               sonoma:         "85e58492f5d69bf7a49fe7383853c522d9cabdf5f5a0089843f289128d1743b9"
    sha256                               ventura:        "acdd034209553a72323d865bbe920e5de4b292a59280bd1d5b932313189ba36a"
    sha256 cellar: :any,                 monterey:       "ce09450b72330d1149d8dd583a6514f6d885340a44455f55829d0a6d78ca501a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22992924f031618d9172e5c0f08e3e6e3337e9658b29604494abddd1a2af60f5"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c"
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
