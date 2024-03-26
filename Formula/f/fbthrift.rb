class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/refs/tags/v2024.03.25.00.tar.gz"
  sha256 "2a325446cd3a149a892c0c6abcb0f6f6cf83b72266d83ad279d2fdd9340aeef2"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f992fadd6323edfc74f55c2214d4a2192d3b6b4e73f8b49624f236ffc1f4a977"
    sha256 cellar: :any,                 arm64_ventura:  "502b6da49862cb282dd05a148a580160990ebb293d4fcd58c4d6ba8692ab74eb"
    sha256 cellar: :any,                 arm64_monterey: "7f41ff4bca68c2b357e7e2743598401635f99c75d74a4b1a54e5330a383c3f4c"
    sha256 cellar: :any,                 sonoma:         "ce0a011c036fca56e34e0cbf9e1454949a457955e11c81c480bff58d3efb723c"
    sha256 cellar: :any,                 ventura:        "e6236cda1e6898c9be2ddf113b1bbb0b3dc9c7b75da8c026acee6994d04172db"
    sha256 cellar: :any,                 monterey:       "eb018c41d6cc0188611ab8c21f5f49be9d46a2ba9a298e75f1deb159e7e4fb7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15cd7c95c4a5b2b0c50208b2713fbbe8d5722a7273fd577946db433585234438"
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
