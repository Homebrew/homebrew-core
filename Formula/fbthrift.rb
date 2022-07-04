class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.07.04.00.tar.gz"
  sha256 "45e7ffb38655d9b518d28066f4276000a298990c7c32b9460ddb7a37f2af78bd"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "94e122fa46b43c2a0f026ebbbce45eb7af2f79995c64e84836822e7b6326f644"
    sha256 cellar: :any,                 arm64_big_sur:  "4c6e83865fd4548fc93d5fb4f4f97f42251b6e68503ee7e54f5e9c0dd9e411e4"
    sha256 cellar: :any,                 monterey:       "5d33b569f5577921ff6aef7c9c752a7fc9e71346e2ee4cc0710e5d44f9b22569"
    sha256 cellar: :any,                 big_sur:        "e33a9e67ff0e66670e6e796526f353dd81e01232485ba3a4df6f2938d487f654"
    sha256 cellar: :any,                 catalina:       "e4bb4a7404f2d6751c8f9077f0726913697898b95a2f61bdc84865cc67aaf9e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b66fa31360c8d22ecb54619270c7bb1de709fdb0010596ce2a61669575e9532e"
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
