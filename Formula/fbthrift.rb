class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2023.03.20.00.tar.gz"
  sha256 "c91f2ee85f1956ebfe9d518eeaf1907451568fe1be26da742bd1729cf7fc338d"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f59e777a19a6cde2c9aed4b2dcd9124258837266224ac6e49987ec71a7f581ed"
    sha256 cellar: :any,                 arm64_monterey: "72963c82f1e2aba363550bbadaf426e90f3707352bf8a7a2b8c0f2d663aa060c"
    sha256 cellar: :any,                 arm64_big_sur:  "6e66bfd3f30b92509c4203264568a54ea78d2d025955f0ef3725913f80045f18"
    sha256 cellar: :any,                 ventura:        "587cfb684292417bb7900ea3f74c640bb171f48d8e099027a68b13134d10b86a"
    sha256 cellar: :any,                 monterey:       "7d0482ba6e83ff9fd6eed2a2f1936aa1e058f0d80e5ce8ff837a04860e5db7c8"
    sha256 cellar: :any,                 big_sur:        "a6175ef92465201542572c5db8480ad9a65036e5342ce0c88143f1ea38a346bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6166909c9b7833424e50820eba28f3b00588125590c5c71623c9cd763231a767"
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
