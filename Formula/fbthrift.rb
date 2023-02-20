class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2023.02.20.00.tar.gz"
  sha256 "bd71cc5977d56c84a6a1f1da960c5898ae5d66a2da17f69fd3fdecbf56b1b225"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6bb3aad4359fb20d326649fb5358fc19f30b89349984eeaf77ef4ffa923818e1"
    sha256 cellar: :any,                 arm64_monterey: "2af159afdbc42dc94ed820276c89cb9d4d43b675c180e6cb6eb7576a9de2eb36"
    sha256 cellar: :any,                 arm64_big_sur:  "1c03c3f4141ebb76090e01a46765a4fa8b82b8a9e13d5a1e411de9eb76c76a5d"
    sha256 cellar: :any,                 ventura:        "a09014ac0d0079ee94ae5275ebb6322f6b6b79749a0c9a1956adb31e0d2a4123"
    sha256 cellar: :any,                 monterey:       "13f271ebc347c1b20f79b30708ed6f06f842b514cf4e1fb5d8f5c89ae3e95500"
    sha256 cellar: :any,                 big_sur:        "4c42af8aff0b196a08e5a4d52851f5311d17a266785b9c2902cfabd4bc4d92db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23d096f2bd050fb431d5ab4c9a7213005badfa844624177ccc4f0235c5ce1cfb"
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
