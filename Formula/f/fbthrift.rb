class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/refs/tags/v2024.01.08.00.tar.gz"
  sha256 "31250e325acd763052f40764154ceec9517da4a8e027efc132a266daac82d486"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2bc2be3a4199fb07854da3aaccecb1645321d78c0124090246d340b79de96ca3"
    sha256 cellar: :any,                 arm64_ventura:  "0c1b0cc7b9f7c6860c0f1f0d3334a24a60c80b8c0802576764e1fd3199679d7e"
    sha256 cellar: :any,                 arm64_monterey: "ca074ad361d5ef8bc296e0744bd66e6bb8ac8a250ae9af166540d80d50380527"
    sha256 cellar: :any,                 sonoma:         "38be1f1cd22955adca2f310a96840219b5c4337d87aa606524d44311b9856692"
    sha256 cellar: :any,                 ventura:        "df8246ccd668692628f9fee5da5c8e8c45d50c0fc2eda8d5da34494a3b0e4edc"
    sha256 cellar: :any,                 monterey:       "80a7843793abd3c5065c334af5fdb6865957ffdc2c5f8cdce80e75dc3134318d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fa780c277c482d1b08aaa5bf4d0eb68cd1ad1c8c26ede353861594693556cd0"
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
    ENV.append_to_cflags "-fPIC" if OS.linux?

    # Setting `BUILD_SHARED_LIBS=ON` fails the build.
    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args
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
