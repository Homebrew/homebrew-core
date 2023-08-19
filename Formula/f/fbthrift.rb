class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/refs/tags/v2023.08.14.00.tar.gz"
  sha256 "852fc394d79661fdd42f9630a37bd3a99ee76542c0526539d38b77edf359a323"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "befb7b8264962dad158fad01a24937aee05960cfff4158bb08a15d193a17b2d3"
    sha256 cellar: :any,                 arm64_monterey: "78dd652a357014ca251d0f39f5e57a161addfc5eb52c4554089197cf7af24cce"
    sha256 cellar: :any,                 arm64_big_sur:  "bc44f75a0611d56bc3b934a91a28ee3ab2387de1b245d49d4059dc706944e3e5"
    sha256 cellar: :any,                 ventura:        "6a6dfe9499d59dd306a5f07634896a8ae406a5358bc6a0334a27285666b87679"
    sha256 cellar: :any,                 monterey:       "0566acae57949825e7a8814f3170cec2c5317fcec6130e18c399593ae8532abc"
    sha256 cellar: :any,                 big_sur:        "009499bf9b598cbd163d0bf2bf13704d158fdee3d32bf8ecdadac5242fd57c5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5f4367cba695ac5f64c2599fe8b5b4d12cf239714c631bfeadcbb89b18d68c6"
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
