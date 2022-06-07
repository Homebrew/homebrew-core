class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.06.06.00.tar.gz"
  sha256 "add554f5f4139f5fe16502a279f3b1233e3f30e56efa387728d59a10dcf6a053"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d252fd957d6dcc46538dcda7c5aa7e65694a8c0a67ead253225863bcab1b8feb"
    sha256 cellar: :any,                 arm64_big_sur:  "09ac065e9b2ed96188b65cfff09f17fcece43dba04e8c99f91d371f0f2ef1091"
    sha256 cellar: :any,                 monterey:       "d99fe548bcac9766cce6239358220b3ee4a740757a9bb75b6b5fdc868931fb78"
    sha256 cellar: :any,                 big_sur:        "89a5dd794e5e495109f5b6ae6f54215493a91790bdde1d5dd8df35c75a6fd635"
    sha256 cellar: :any,                 catalina:       "acacca9dbfcce577abe7a2f958f358bd5f6c5ad5283793db59f16c337f4bff67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a135a850088ad1ab62d656e91e6729d22398d61e9e21c91395aeaa4b2076ea39"
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
