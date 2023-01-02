class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2023.01.02.00.tar.gz"
  sha256 "fa8df52262268e97cbc349b18ad686bec2ecb56ceb3774e2475f947adea41178"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2a597a5d930bd33c618d514de697ef056ead3e5763b8400276ed10a60a7b2518"
    sha256 cellar: :any,                 arm64_monterey: "b80d965f47c2f1c5203d2126309e8fa26e6ae34886816e3c8d4b454eae940273"
    sha256 cellar: :any,                 arm64_big_sur:  "c89071118c20813bf97f448ccbd12126f1e5b45a47c90bcb327fc2a674978bdb"
    sha256 cellar: :any,                 ventura:        "ea10c635d41ae0fff94f31fdf0d6d6b9c721357aa42a03c4f9d678c3b9476618"
    sha256 cellar: :any,                 monterey:       "e6d9148e1863add554f8ec830f020a76a2a5739483413c3a0585913bcc03cc99"
    sha256 cellar: :any,                 big_sur:        "c03558f67c84747e281be000d1489060e497da31d6c30f01e5e387c1d8b613b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33e8f3d2aa90bbd1e2ec54eb39dda0c609553a6f828eb4d430e20d80de95bfff"
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
