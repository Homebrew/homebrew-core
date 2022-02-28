class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.02.28.00.tar.gz"
  sha256 "43ead66f68d6dec1bc4968efc77360cf5cd4d8892266e58f84a05fda0c5dc30c"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "384444ce763976e1051aa03c5be11b343e5d87672c2bd428cd65d800270b9fe4"
    sha256 cellar: :any,                 arm64_big_sur:  "e006fffb21ee2a0e09d085330a8430e8233fc6905ff78b6f9db7014ebb9547c3"
    sha256 cellar: :any,                 monterey:       "c2281309b5d4fa6132da7c771d21e18b61202a8cc4c2e181e685ccee0e3e1390"
    sha256 cellar: :any,                 big_sur:        "b3da09e30519c495a21729714cb61fb4b231f4df207575952fd99770e3462e4e"
    sha256 cellar: :any,                 catalina:       "3bad5a1a6e9f4fda83a489c422d113e04252f3a813ae5b40eca283907ad3f453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd67879c2efc7d36c0235e5261424afe9e355c352a2b3f34658ea272bf2d0490"
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
    depends_on "gcc@10"
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
      error: 'asm goto' constructs are not supported yet
    EOS
  end

  fails_with gcc: "5" # C++ 17
  fails_with gcc: "11" # https://github.com/facebook/folly#ubuntu-lts-centos-stream-fedora

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
