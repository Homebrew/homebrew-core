class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.11.07.00.tar.gz"
  sha256 "6f30d77751635cbf440930f715d22ef0eea523a8c0bda3babddd16cd18c0cd32"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "03508beeaf91d13d7f200f887b96fd940b4c83f70bf0fbc5036be074165db357"
    sha256 cellar: :any,                 arm64_monterey: "406723713ba5a9b7bf371c9c0a3186d2fb01363fc9cf9bec8597e25183730754"
    sha256 cellar: :any,                 arm64_big_sur:  "8c5d3527dc62882fa092e0f49b7d498fa947390f5c28c422cffc55883458c51d"
    sha256 cellar: :any,                 monterey:       "cfe94a9ebbd78185809ddaa057c6ed0d4280794e3d4e5e91e3b5b6d7cc7a1818"
    sha256 cellar: :any,                 big_sur:        "df1697c874a432642556d981fdd70e41c6d7d216de574b72a01fff27f9dfc058"
    sha256 cellar: :any,                 catalina:       "ddbc5732914c495d5e9ff5e72043738d32f356b61a099220d31c80c5a0b5709d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aed3d234bd3780a48c748d14720787018f6a43d99f4b9753209f852465cf1932"
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
