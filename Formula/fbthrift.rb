class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.09.19.00.tar.gz"
  sha256 "13a22e25d3a54b76d53019f84feb2317a1633f2fc4ba217727194e47db36ee66"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5aefee73cd36a535d8118b66ee2301435133b710c2ef220b7bdc5421a6c3733b"
    sha256 cellar: :any,                 arm64_big_sur:  "aa39a2acad545ef0de25e71ed2129b99162c9b6d302a3037248f005c65e23bd7"
    sha256 cellar: :any,                 monterey:       "be9a7bd2cbb701d76aa72e63e8f3b69353a9966c6d6030168869f29a21773b6f"
    sha256 cellar: :any,                 big_sur:        "46c9db4975e8502eb322e46e4aa38dd83708ab2c60a57c80ca8e6e2a7c59e5dc"
    sha256 cellar: :any,                 catalina:       "4075b7e398b2dbbe3cb1d953062dab8c5c874ff6b80bbef0aaf7c5611b8ea559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18a30c20420697e12be239bcc4eb43d0475a60bbb945af6b88453168570d5baf"
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
