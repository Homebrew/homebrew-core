class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.08.08.00.tar.gz"
  sha256 "6b5165b4f5115f3537b9b5843f2dec21cd4836e6d69d8562dcdfae13ca8ff322"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "49abcff6bb84f5d73631aea21ddfde5ce44b50a37d22f01ce9d8f5721a90b512"
    sha256 cellar: :any,                 arm64_big_sur:  "3d6ee2d4e8ee22a7031c094bb5050b79b2bb9a9baba297af4379f8ecdbe209d9"
    sha256 cellar: :any,                 monterey:       "af31f8c0ebe4646110eec2f4f2805974345d447dcf17447ed6aafd9c76e0eeb1"
    sha256 cellar: :any,                 big_sur:        "9a85de635c674e06c6cc874ff4c518e2df66618cd7a43f48ea0e6eac21fa6a1a"
    sha256 cellar: :any,                 catalina:       "a1e967071a280a25af75cd49bb810608cbf4a0d4f4c6f39dc25f3d75a0b5ab11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eaa9741a31e28e22b537c368cd17a45a2f2124b85a7e238671f6f368490efad"
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

  on_linux do
    depends_on "gcc"
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
