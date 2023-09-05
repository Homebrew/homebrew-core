class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/refs/tags/v2023.09.04.00.tar.gz"
  sha256 "8d622f7a37bcc314396627f2a8a56b53c8898ee677934c9b703924d4366fcfc9"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c49ab539457fadaeb4091cc44280e66ed17f10e1ea92b3884b2cd8be49686897"
    sha256 cellar: :any,                 arm64_monterey: "7b83415e6143e14e871dfb4b5730cdbdb622f955e47729c1f04fbb04726c7fcf"
    sha256 cellar: :any,                 arm64_big_sur:  "0040b7e042e0420afdf7440fdd983b5c9b2448b48928f4695f34a8e22825d8f9"
    sha256 cellar: :any,                 ventura:        "35acd4fe9ad191034acf0efe4f69722263768b66dc99ac50fd3de68b6b904d2e"
    sha256 cellar: :any,                 monterey:       "018e4621a1549e2fb4389f6236aaae43ba23c6dec342d26e03701d8d1f93d8ae"
    sha256 cellar: :any,                 big_sur:        "972abca39c2a47a775f66b34292b5f0474581fde526a7011b5eb6a2ec57b945f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9508051a76f3a573e14a98ec1bf1d86a7923c4da91d564e451d3c2dcb957cb1a"
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
