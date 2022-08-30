class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.08.29.00.tar.gz"
  sha256 "85d9b579d9edfe1de83cf9f4981bd9c1e11a39ce9daff5e7cde2efe1bab708a4"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "49b9ae718b2a78880478daf31e9b42163446c677a9451973d3cfbe6dce3bd756"
    sha256 cellar: :any,                 arm64_big_sur:  "985b4bcc01f0cfd5bead701bc0a47abf0332fe922145a33217a36e9396762e43"
    sha256 cellar: :any,                 monterey:       "5f2785594878c3099e8f59d71f0a68de4527092fa6b3bee87a5a740f7b8fe1c2"
    sha256 cellar: :any,                 big_sur:        "50a4955458e2adfd938faefb491c0406f4ec9807f3b1759fbcdb8b7299ddff4f"
    sha256 cellar: :any,                 catalina:       "a3527004dc6d538f21c2656c411fe99d172f087b83e6ce87bc232475c34ef34f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3dba4322a9278a7e3ea5c1480c6cb383ddd8d8e1fe68ee83f95c6c05ce26f55"
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
