class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/refs/tags/v2023.05.22.00.tar.gz"
  sha256 "bf509688bdde6b8435fabef65f4ec7b046b7ac870e07cbf46df994dba34706ba"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e60af790c1c915c44b251609556ddae5f047cce079609ad39bffd801f35b9329"
    sha256 cellar: :any,                 arm64_monterey: "5ac0d6d1f0c644d16df2a8de0af81be7cac165f51bbed826ece81895fe72dc91"
    sha256 cellar: :any,                 arm64_big_sur:  "633a191aac461cfbe375378eb401c966b5142b0a10fabdd2c4d7e82632b1b3d8"
    sha256 cellar: :any,                 ventura:        "5478e80ff36caef0babb7fcd13f0ce334c86b5dc7729d34d79d6327a3fb44f5e"
    sha256 cellar: :any,                 monterey:       "b4df6594f9d4594700e168062075701abb4816d9714ca22c6eaad126a3daf514"
    sha256 cellar: :any,                 big_sur:        "230862bb90b28731d250e83f89adcac44fd57ed6709514778ad6f6f7968c40d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbecc1d2d565ee1df4960ef2372e9e2ff28b916255ea3a3fcf539e0ba11c63c0"
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
