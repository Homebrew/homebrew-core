class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/refs/tags/v2023.06.08.00.tar.gz"
  sha256 "130d6453692ed4f9ceab8ef6b3099bcaaab33f7d244f68674f3f5d1fab31773e"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "52d32c8a6e45b636af6e408cdcc4cbf53e46b6cc8c8492b7caec43eee7479cd9"
    sha256 cellar: :any,                 arm64_monterey: "24f241082cf09c984d545465445ff50b6bf20dd4d43fd41ac8cecfe339b44c94"
    sha256 cellar: :any,                 arm64_big_sur:  "4b012b56201d68495ae013eb1b473ab79fcd87d52bf70ab2b29a7cb6563926b8"
    sha256 cellar: :any,                 ventura:        "65a21fbbec53c02262f9cd61757e72e0178cb702368e1beef39c9c554621103c"
    sha256 cellar: :any,                 monterey:       "aa74e788d58cfbfca70ee36451503bd6ce8e8b0bade516c43838ae5e230736a5"
    sha256 cellar: :any,                 big_sur:        "64b1213107fff1e09a366d234dc6b8d20840234660186e689c2fcd6143edf8a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01c010daa61bb4e936de43aae886e6b801bb25b72087ac8d42edc76accc1b007"
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
