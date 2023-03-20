class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2023.03.13.00.tar.gz"
  sha256 "689509d03ddc02b7f7fdc7cb71140a6509eaf869d84720654a25fbdf0af91a71"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4a4a7427e3ac4580f3b7178977a4a7a13262bfe82507a78bdae336856d07a481"
    sha256 cellar: :any,                 arm64_monterey: "d3442e98fb43baa9b2c1bb330a168cdd153a920c09dbe4716b14fee4d79ee2e3"
    sha256 cellar: :any,                 arm64_big_sur:  "85d3ca525da816aecef989b92b580c089b6512a726e15c7a9a00eb90a4d7087b"
    sha256 cellar: :any,                 ventura:        "ff6832f06b463202b3ee37fa76d5017d1c61b44801aaf3559ca691c46666b69b"
    sha256 cellar: :any,                 monterey:       "ed4f4204f5e920a64d031c3386c62e15155ab7b8daa27a1a46fafa2642ff4eb7"
    sha256 cellar: :any,                 big_sur:        "b31e32bb7485812b770bce8fb34cf15919f3e1fb2ead8c72996f4ffe6906ea0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5b3478a433903458285751703c1246437fb8c0ac548903457c357938b4c8a93"
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
