class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.01.24.00.tar.gz"
  sha256 "a9164d8f16ed90c5990815cfb519a17c1bac390a61549df776703f9f636ad45b"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "de3377d122b01c37dac6d0e490f44a3f3d435aad6aa3269dcd3a204d690b0f4e"
    sha256 cellar: :any,                 arm64_big_sur:  "d476f5d9e84f411f636c4b9bfe478c5f223125e6db2e9a4d39720e31b07729cc"
    sha256 cellar: :any,                 monterey:       "ed71ac84c714cffa7b227934f29aa2b0144f1aec1988fe282bd09c8aff2154fe"
    sha256 cellar: :any,                 big_sur:        "7b799e8c8d3b055865c79944fea4e05b9d1b48ae9187af8ce0f76498af71c222"
    sha256 cellar: :any,                 catalina:       "9739ddc87e3c585cf9b4cc39651082ec64d7a5aaf46fef793ba05a640b32af45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af3f8d7f93bdeba9469214e115f110df2e9591520ab2e89b693eae43bf5ea96a"
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
