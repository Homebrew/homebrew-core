class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2023.01.23.00.tar.gz"
  sha256 "9a30458a3098e4520f08eaacbe5bff58a8fcdb465951c9983882522e35ea9ecd"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "25bfa8c4bc486e4988f34992d2ab81bac202aa4fb88ad1da36692a88e4085af7"
    sha256 cellar: :any,                 arm64_monterey: "cf088a7fd286c43e7b845ccd7619e81ee530ec0a23b424c94716803faff3df9a"
    sha256 cellar: :any,                 arm64_big_sur:  "11f3da4332e307e36aef8a7a896d4c3d1fe32057be0e33adc03877ded4ca08d9"
    sha256 cellar: :any,                 ventura:        "92501bbf13aed940e2751482a1a2b5b0f336979b70db9fcc891a1c4e933bdde3"
    sha256 cellar: :any,                 monterey:       "3cf30b8c8b4dc58ea174460da50f893f3a1296e75c396b6f2ec4a43a4bcda1b4"
    sha256 cellar: :any,                 big_sur:        "1b3627b4cf513e405a46798337994f26d39f45372ed48bb0a859cca92b4bc169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "283cd94bd530bf6f07392441905c6cf52eb353181b932ef66cc3c647b9c277b7"
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
