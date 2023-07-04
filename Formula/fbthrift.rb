class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/refs/tags/v2023.07.03.00.tar.gz"
  sha256 "fb64499357062bb77cb49273368421fb3037aed3a8042303540b48b7a4bc2731"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8bf3b74641b6c330c5d4536d033e4852513a7b092adc59aa7339114c14964794"
    sha256 cellar: :any,                 arm64_monterey: "1050d140f6ab8cb73d129f5ea05b6a8c11f789cccac0d1a976be6f61b46424e6"
    sha256 cellar: :any,                 arm64_big_sur:  "5a146bb45d3833270a585a6d2aaf8c3bddf7bd3e42f55cfca4b36f47e7bce043"
    sha256 cellar: :any,                 ventura:        "23596ad335a0b27e8eca6c09fbd00c7c893e5a2fa859f56dad1e50dd3fb1b568"
    sha256 cellar: :any,                 monterey:       "b234a07a82382028626b584eccd1ed18c846d811d28d71bd593ab15a2b6d9707"
    sha256 cellar: :any,                 big_sur:        "1e65c62a80140d85b8905261e7a865c8b2c00925ac0fb8eac0544bd039677fef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f285c4e9064e475776756a5564cee33fdb03924e00f974b6c2d660eee72bfb5"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"
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
