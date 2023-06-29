class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/refs/tags/v2023.06.26.00.tar.gz"
  sha256 "07872d145b9d941a57b2c7930696506736f29bb421b2b40676445b6382289d91"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "056c64f565f65ebc9c571069e38c5e18fe81b0f3d65e136d92998f11afb9dd88"
    sha256 cellar: :any,                 arm64_monterey: "b1df543f0efa3acf6785f56c911ee33464be328b8c0eedefd9d0e5aec19b1aaf"
    sha256 cellar: :any,                 arm64_big_sur:  "18779f79e0b0d451f929b5118e45e5f82b0f5208cd61cb3105551ad43abd5428"
    sha256 cellar: :any,                 ventura:        "f56c236b804df6e4e8086d9d466efce182707ebb814e78978c2e87049c02c539"
    sha256 cellar: :any,                 monterey:       "fedecfc367697a2042babfdda9ed9df4045bf691b224f4f3a70a111012eee588"
    sha256 cellar: :any,                 big_sur:        "5d910d2dcabe6e296a21bb516f84e7dacd7f79267fa95578bd54dcf3f2b33733"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e523788301d4b9a2ccc1d76d0f680c83dc02fccf03e78dbca717acda06d7ec2"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => :build
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
