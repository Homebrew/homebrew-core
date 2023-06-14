class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 6
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2f919c5d6774bf06f6c29b2f3e1e84c228e512ca8af21a9d24e385e8269504e1"
    sha256 cellar: :any,                 arm64_monterey: "1b783f149b2b2d243d515f61eddafcd15cd315a53b862a4233fb38b202c26805"
    sha256 cellar: :any,                 arm64_big_sur:  "7c61d426d7dda0cae30644938d7ebf5289e70717bd6038dbac3cd3184fed6666"
    sha256 cellar: :any,                 ventura:        "b015007b52482f69aa65421d8187a62c368c6038d34ff4ab808fdaa34cfdc7d0"
    sha256 cellar: :any,                 monterey:       "0a09cde226ff346199c2402eb713329b5f6eb88b9abeebdd3fbcc71c650411bf"
    sha256 cellar: :any,                 big_sur:        "18246f82d652bd30dbc94ce91609b800335fd9266de08aa00c18e5af3525c012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0d94d5b404986aaba156adb80bf22b25f91d107e70c4f00f50e053a8b5ab745"
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
