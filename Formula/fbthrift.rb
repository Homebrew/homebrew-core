class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.02.28.00.tar.gz"
  sha256 "43ead66f68d6dec1bc4968efc77360cf5cd4d8892266e58f84a05fda0c5dc30c"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ecdccdef2a0ab90acefe2513ff406c9585a218a7a7e1b502658378a88fb04967"
    sha256 cellar: :any,                 arm64_big_sur:  "aa85321bdc46e7f0a1afbb6ea0ba77cfaae1e3a96b869f1fc4ba96ee3a75dcdf"
    sha256 cellar: :any,                 monterey:       "ad4c6c2a18c6adf3d826dbc57c9cade35c875b55951d788ef9b7c632c529098b"
    sha256 cellar: :any,                 big_sur:        "683b452fb6f31bd2b5844c6ff5bf1292e7574ea313f42933a578d76d64a144ef"
    sha256 cellar: :any,                 catalina:       "6725110deaa90be9dd97b5e3ed04d1c1944e7bba3aeab07088ca455b9ac93d17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57ca5f58652cfdc825b1b272b3f128577784ac46f3902a215418379a7bfa9477"
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
    depends_on "gcc@10"
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
      error: 'asm goto' constructs are not supported yet
    EOS
  end

  fails_with gcc: "5" # C++ 17
  fails_with gcc: "11" # https://github.com/facebook/folly#ubuntu-lts-centos-stream-fedora

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
