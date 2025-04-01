class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/refs/tags/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 17
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "e080964e877d418f39bd35812e7204a506b3b2a764fa66cb4ceb91b6c77b98c7"
    sha256                               arm64_sonoma:  "b08731624e7c1dac0562ab47638f110fe526111d4da870edc2f7fd03a71dd223"
    sha256                               arm64_ventura: "aefa31d88c0692c5700913b1b88eabf2bd816aa2b731e6fdaf2b05419f733d10"
    sha256                               sonoma:        "5bbd538d58f0711587b6779c333786e0a123190eae592832c33d0dc32d53df4c"
    sha256                               ventura:       "80b1749b97903be2636a03542efba684530a828d280d6c515325fe946542dc0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54052e75ae9599cbc7e525f934badda74d09feea58f5d9086af2f42c69a619af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c369362a0db97267892474a7b27dc13d865a3ed5dc12354af54a775489a8e165"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c@77"
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
