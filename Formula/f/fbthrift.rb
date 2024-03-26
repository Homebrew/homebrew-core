class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/refs/tags/v2024.03.25.00.tar.gz"
  sha256 "2a325446cd3a149a892c0c6abcb0f6f6cf83b72266d83ad279d2fdd9340aeef2"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a1904974ffa144219c4ae561c79fff47f2e29fa0f8227d33d83ebc60183ad9e4"
    sha256 cellar: :any,                 arm64_ventura:  "708f66133301f7e81f04f58b34f6a04d14ddfca86516ec1f8f27c1a274b9e3b0"
    sha256 cellar: :any,                 arm64_monterey: "aba54291e7bd6d8768ba00a55a53a76523978dd70053175705dbaf5844635e9b"
    sha256 cellar: :any,                 sonoma:         "f964cccca9310d3a83c9dbfa92020b995d34695b19c9296b379e9ca3fac9a368"
    sha256 cellar: :any,                 ventura:        "f0613f2dceab196aac8740e952e9b5463c25fca647223f2b3537453ecacf8504"
    sha256 cellar: :any,                 monterey:       "5488fbb1d697639f8b1430a99f9df67272b685268cefb9d8722fa7403c8e8c2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27966a830aa0081fdbe733286f0a9bed1bfde5f9bf7452c539b8d3d3d20f8a16"
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
