class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2023.01.30.00.tar.gz"
  sha256 "66c785a116b52d36cc113b9e639471bd89ca67bdd422f85fad1e44dfa98d7a8f"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3e8ef6ad7a0381516705e2e731ba59cbfb7655f584df2e300682188aa060f04d"
    sha256 cellar: :any,                 arm64_monterey: "6f5678b32e9d003447b39ba4ee099650410a2a83061350ee05a4adb43bd190dc"
    sha256 cellar: :any,                 arm64_big_sur:  "e3380d6a185e245f27718ab2b7a4a20f9fc5ac09f8956a6b62a90a51738e1998"
    sha256 cellar: :any,                 ventura:        "354696e7c6cbd328c071468fe7555e2fdf0f4ad07d11d8242b70735e253793ba"
    sha256 cellar: :any,                 monterey:       "5c790182e997ebbd9722bbd7dce94df9937aea2ea3e0f57b8182338cedc3f09b"
    sha256 cellar: :any,                 big_sur:        "4e9779d1b0f914cd861f928dc746765ccac485b8edacdc73f0a19574c4156d6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c0db8d779d21471197d0b49e5252b17056380caeb193ca2a5bb9285b7b54483"
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
