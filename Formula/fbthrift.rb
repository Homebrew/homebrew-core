class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.12.19.00.tar.gz"
  sha256 "c05d8a6df30150000974c20274ec07a57cc212e15a4d06622e62feaa1255204d"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d1ee3d51d375205f111ae4aa081054fdab4f2f1fa47becabb5a7fb02f0e52aed"
    sha256 cellar: :any,                 arm64_monterey: "adb4eb850369c615e87bfa34cb866fd57ce0cafe5f604ceff37d278f5a6b8ee2"
    sha256 cellar: :any,                 arm64_big_sur:  "c96f9fdabfc9a583b7c48758e37eb7152fbcf85bec30f05ec58891a979e61c54"
    sha256 cellar: :any,                 ventura:        "432dbd99a219a5c53394a79ec1157d025bc8768693768fbee4da3cba391a37bb"
    sha256 cellar: :any,                 monterey:       "f3928c9a9adccad4da58c9dce6f85a1253d5f3398f1982db7a7f99f7d44b5948"
    sha256 cellar: :any,                 big_sur:        "45dce6d4b02ecff48d24561bfa47f38e3ef1797ed1ba8bb26fdf7ac5cb05c457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0c7594749b932447b1459b9c5879f54d4337e3d337581f43afd12b6cba800a5"
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
