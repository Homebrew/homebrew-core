class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/refs/tags/v2024.05.06.00.tar.gz"
  sha256 "2e97b34db97cb2b328bf75b9528c8e2a9fc37e858a0c7982cd66dbd8911baa8a"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2c5b7776e68e84b9a4265b3c1327b98672193fff4898816bbab6bdcec3a7db50"
    sha256 cellar: :any,                 arm64_ventura:  "e901246743cef9ae3550c788a6440a913cc9ae669c0318ca7e6b4fea33be69b8"
    sha256 cellar: :any,                 arm64_monterey: "7fb90bab06218f799b528f95b39a257be88f40cc8e0896ae6f0b0af5a1b655a4"
    sha256 cellar: :any,                 sonoma:         "152387131bcd9ee2ffa9eb5333b71e3682cc72e02ed4ee39af61190422610593"
    sha256 cellar: :any,                 ventura:        "45726a08cb6fd059cfda548a3da0590e6a67a409d808d0014292032d40d32663"
    sha256 cellar: :any,                 monterey:       "414b34bac003163fb682bac0ce73d063e01afad59bb2a1feb62554b3a9421a22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "519768522060a94928e4d07aed42b404bfce411c23669863061355df023dfc75"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => :build
  depends_on "mvfst" => :build
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
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl@3"].opt_prefix

    # The static libraries are a bit annoying to build. If modifying this formula
    # to include them, make sure `bin/thrift1` links with the dynamic libraries
    # instead of the static ones (e.g. `libcompiler_base`, `libcompiler_lib`, etc.)
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cmake", "-S", ".", "-B", "build/shared", *shared_args, *std_cmake_args
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
