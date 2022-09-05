class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.09.05.00.tar.gz"
  sha256 "9eaaf1702b57b3098e815ca05782c9fe35c8e6aacaeb38a8d33152f1dacc9baf"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "228e0a15e797f2cf8ae8fef3a0c7a9d9ad3cbbd0ad36c4aaa8c5d23e6c2ef691"
    sha256 cellar: :any,                 arm64_big_sur:  "d7bee8641c45ed227021b6f883fd47183bca86fe5a054cadeb06eb02ceed6539"
    sha256 cellar: :any,                 monterey:       "cc094821b3a23f1da3af2a32891db889802b3d84b06db891ee4cfdc66ab877ff"
    sha256 cellar: :any,                 big_sur:        "e4ef1086bb6a1df4519ada840a9333612e221eb91b8ff139037eba1ea9eeaefc"
    sha256 cellar: :any,                 catalina:       "381685206c599cb4bda65fbb54efaf14a2dee419acc7cfeca0f378e54239f38e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "155260b8755efd9554c9eec33c0cfd6bf85172a1c8e6887d12d344552ce4ee7f"
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
