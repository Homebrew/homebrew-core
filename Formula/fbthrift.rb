class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.06.13.00.tar.gz"
  sha256 "d2a8cfe389523190e51a88329cce3cd20a01adb5376e17d0ebd2ddc5a8206c04"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "66a78ac3c161cb10546005dc42a1a1f169e52f8e4e8b1a2a9d14e2db10df30a6"
    sha256 cellar: :any,                 arm64_big_sur:  "cb4c164c0f7a66bd0cf4f7de13d074a434e7a569101efa5614773d9e5d4bad46"
    sha256 cellar: :any,                 monterey:       "2da9b2a25923e80304fc37f48292bfb63a6a0ab73ea47599e83ae027951d293c"
    sha256 cellar: :any,                 big_sur:        "eb46d964a4b3c053022ee7589ffad8163ced2129597fdb5b98ab079d39d9c276"
    sha256 cellar: :any,                 catalina:       "6f6bd47bcf51bba23cefbd3433291402b1ce49fc34e1b5ea776c817419e5164f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf06a4459931712386bd568d21cb1e4b1245c492d9ebb1d25493f93bd969ab80"
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
