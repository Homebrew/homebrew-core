class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/refs/tags/v2024.04.15.00.tar.gz"
  sha256 "1921a0fbb198c0680d9f71bd795381e27a211238ba8d2a8e3c275907c768ec3c"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0b1669dbca282990affd539e859a11285de56c87464e8e9a1bfe14b55fd5c590"
    sha256 cellar: :any,                 arm64_ventura:  "e538b630fc77ae3352d602c166458e98d9f6a7a1f14ef3e41ecfc23b5e965add"
    sha256 cellar: :any,                 arm64_monterey: "7619a6d7f35a5e75ce911a1b381f003477e0cb59585cb7ac0ed3d33033cc954b"
    sha256 cellar: :any,                 sonoma:         "24375dc11ab1050f8e39cf6cf03e6cb0bcf333e6b451a5ec5ad74254fb2d0d1d"
    sha256 cellar: :any,                 ventura:        "88822bd58e38803fe359d91325e31a485acb738ac39f38bd338d185903ba73f3"
    sha256 cellar: :any,                 monterey:       "7c8938152cc2937648671f8ba1f0b1a3292fd54d9d793171d406eb8ace001472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f9339ccdd79bcbb24596754680a0269427ac10e1bd8d008c4edb1a03fa553f"
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
