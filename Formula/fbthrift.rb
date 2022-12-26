class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.12.26.00.tar.gz"
  sha256 "1b5cf43736c32f7327ed67c9dff064f9d7d01efd5a330af2014e757224105bf8"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a2af749cec3714df657a5d316cfda41f6ff17ba81a7fc1573635f005aa5718d2"
    sha256 cellar: :any,                 arm64_monterey: "bfb093eed1fdcfd0ccc8e7a67ed0e6377471a2a859a3672c45f2dfe2470e4e86"
    sha256 cellar: :any,                 arm64_big_sur:  "224345214c4380dfffd0557551a7feaf05a6ceebf01a5169a2575a7d1a286210"
    sha256 cellar: :any,                 ventura:        "4ef081e5967fb98e8cbe56c523981bec040478df180f262f4b57a90144f88cea"
    sha256 cellar: :any,                 monterey:       "c72267b6ce12c80bf6937017529d26e8506d83996bf8796e365d9c06a4a7e5d3"
    sha256 cellar: :any,                 big_sur:        "f1e95afe2679f26d488e2376b200fd154ed18de5fea9c98569b24cdf2db85f1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4e06ec5245b61f2d7d03da15b48455bc0c6a4ffb147712e385f5670c7f2186f"
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
