class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/refs/tags/v2024.04.29.00.tar.gz"
  sha256 "fa1d00333258715bfa8a5495545fbf36cc5670d37020cabeadd49cdf7b7638e4"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "967d1c4d3f6cbb220ce7bbf2fd0a40b215455b8a4f2a0a27321420b4054eb4a5"
    sha256 cellar: :any,                 arm64_ventura:  "c393028edbda94ac6dc818cb6d10770e8979ac0f9b8adca8d0c898ea5a2c0e4d"
    sha256 cellar: :any,                 arm64_monterey: "ed2613ce420534ab81a82a171316d854ae820426398a844ea80236bd1d7aa24e"
    sha256 cellar: :any,                 sonoma:         "7702a8469036828feeeaa446a180fb16f5eeb73744210a127ef5f51ec3fa2a12"
    sha256 cellar: :any,                 ventura:        "f859743153b8970b5b4981b28b3aa3ae3d478cf804e5095bbc2b34cd172dd7e6"
    sha256 cellar: :any,                 monterey:       "13619fc40cc673cb1b5d732cb7a48d60a2b8ad623cc3b845c07b24a30da82f72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22df83e5d019d53765badce88eab3c0843a835d9cfe56434e449dd17b7129d06"
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
