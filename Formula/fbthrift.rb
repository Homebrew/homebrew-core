class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2023.01.16.00.tar.gz"
  sha256 "d22e41bef5603bb4c72e0e6a9b8b7e92862dacee2f253772f368487067699fd7"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4b616f4f0496ed9d4eff9052a815cea12b3e54d571aef2b4f34f7d41bab66fab"
    sha256 cellar: :any,                 arm64_monterey: "352c1f9ab268b03b8830ea15d0909bc9d581e849765686a33644532412990ba2"
    sha256 cellar: :any,                 arm64_big_sur:  "e53ffc34a56e28672e4eea39d867f5765b46133033d3e1c845fb1627818b9534"
    sha256 cellar: :any,                 ventura:        "f4b6e54d05074a05ae5b65b6c73c213ac5c2ef1e17c81f6b405e0973b4443528"
    sha256 cellar: :any,                 monterey:       "78ef0289ba4e382f5dc112a41197cafb72a939b619fa5d7fec0b9a896f8f45d7"
    sha256 cellar: :any,                 big_sur:        "592cfc95cdc6342a7bb120f364b6d09a1ce64f78310e25098d906681e36a88bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "491db546fcc48e04e53c7b56e7e4bf2151f1409b1988d44ae73a046cea5712e2"
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
