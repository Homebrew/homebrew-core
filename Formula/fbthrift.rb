class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2023.01.30.00.tar.gz"
  sha256 "66c785a116b52d36cc113b9e639471bd89ca67bdd422f85fad1e44dfa98d7a8f"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "71acb62be29fac6b00fe9ced13f67c2be94826a9c460ffef65cbfa5a71c951b3"
    sha256 cellar: :any,                 arm64_monterey: "34528bfebabeb464c0cb641ac8da370952fed33afff7781637d5584682e3880c"
    sha256 cellar: :any,                 arm64_big_sur:  "f2d1c0f3b53cf7dd7d9519bebcdee2de6a214f399ba28455240b1024441de794"
    sha256 cellar: :any,                 ventura:        "e9fd5fc5394d7f8ab8d6eb9f5abcd5b028ac7ca80195b9706cba36b51ad5c766"
    sha256 cellar: :any,                 monterey:       "a8ca3b00122871755135bed5f251b5d5305b842fe4702a4b9ba9b94e5b90dd40"
    sha256 cellar: :any,                 big_sur:        "f119eb14d89fa4732295cb3af4d4f0a4fc9413806faa9d7ba0aec6528ac77c31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49643bfcb2842528462574826abc292bfb80697d1c2daa83500913f19eb8e59c"
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
