class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/refs/tags/v2023.06.12.00.tar.gz"
  sha256 "bae7c64b91e80a1d881e7e33bbcb603542af5467ddd596c21cadb76e868c6d96"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ed90ceb6bf554f03d8594aef6e4e4efad603d5eb5f548f1afdba48a1bb9adc3a"
    sha256 cellar: :any,                 arm64_monterey: "f6440e34404ea5cbc04111ad049b42bf8d7406f2843b041ebd896749d96598c5"
    sha256 cellar: :any,                 arm64_big_sur:  "a761796d8d6d7e68d8d22c88698ed434f583ae560837048d448fca96675d63d2"
    sha256 cellar: :any,                 ventura:        "0fe8150f0a8f222ded5886bd0259ac932cf7e26e60ba10aff1a1ea8b851b1b47"
    sha256 cellar: :any,                 monterey:       "3d0738d5b2d1aced0939c9079e90a870492e6f0d23d9f18d7345b3e3fa8364d8"
    sha256 cellar: :any,                 big_sur:        "5c185091f87a09ffd5a5b17f0af6111f285cbdbc8bae678fb2fd64047b35c92c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f74bda26a22706683dc0f8a2c678493e62c2ea621d4e73a8f17ac354f124bf8b"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@1.1"
  depends_on "wangle"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
      error: 'asm goto' constructs are not supported yet
    EOS
  end

  fails_with gcc: "5" # C++ 17

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # The static libraries are a bit annoying to build. If modifying this formula
    # to include them, make sure `bin/thrift1` links with the dynamic libraries
    # instead of the static ones (e.g. `libcompiler_base`, `libcompiler_lib`, etc.)
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args, *shared_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    elisp.install "thrift/contrib/thrift.el"
    (share/"vim/vimfiles/syntax").install "thrift/contrib/thrift.vim"
  end

  test do
    (testpath/"example.thrift").write <<~EOS
      namespace cpp tamvm

      service ExampleService {
        i32 get_number(1:i32 number);
      }
    EOS

    system bin/"thrift1", "--gen", "mstch_cpp2", "example.thrift"
    assert_predicate testpath/"gen-cpp2", :exist?
    assert_predicate testpath/"gen-cpp2", :directory?
  end
end
