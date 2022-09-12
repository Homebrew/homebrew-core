class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.09.12.00.tar.gz"
  sha256 "1e7f7fc20f502c5e0235c5d361f7b1544efdff604c4101fe2d9b8e83b5f921a6"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e8470fc001f5e10453c716793992ea0cef4437b6f0d354a7386249549a0bf473"
    sha256 cellar: :any,                 arm64_big_sur:  "e606e09848d660ca737542d9358d63e4a0d29525c464fe5b9864bcae4c9a994e"
    sha256 cellar: :any,                 monterey:       "ec2970eb8e30ef35e8f4c2098e9ca9e72648161a00b6de1c9f1efe53602f5311"
    sha256 cellar: :any,                 big_sur:        "a392d05fc835167d64e30a6eae2c9dd83b96f69b0ffd0a604ade71f9f6b34425"
    sha256 cellar: :any,                 catalina:       "50703d3305f5c5d224c83c4d59bfe4b716b62d223388427d89546e2ea17c4545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b20ba511cce0c55addd56839d0e12e2322bd07b87c4990e0d97cc5bc8be0d886"
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
