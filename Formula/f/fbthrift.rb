class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/refs/tags/v2024.06.10.00.tar.gz"
  sha256 "a71481f9621891a5094d93a7c49d630ae544a1f056a93811742df6469b95bf64"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dba05554cb9e0b60118b803827fdd1e829c802377550ecab4e32071dfa5b06e1"
    sha256 cellar: :any,                 arm64_ventura:  "3bffa6b4e2cb02d3bd3cea5b9afd53d2e21bb4ecfb19a3c949998c5b625e0f57"
    sha256 cellar: :any,                 arm64_monterey: "2de875042ae0142beeae68e17b5788fbd6ee2072c349f1debacbadb1bab759a2"
    sha256 cellar: :any,                 sonoma:         "7d1887184d0d17ba0b8afb46b28e6ae1cfc384ecd09cc3c3c5582530c8fc6ce3"
    sha256 cellar: :any,                 ventura:        "0d386c09232ad160bcbfee0394406d67074bc0b6da5b3def325f3e02e1d1169f"
    sha256 cellar: :any,                 monterey:       "d5110bebf81e6ffb1fc862decbb36e4da1de6819634b1c2a113c36b9b54bb66d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f476070f9976bb6923b716214ba776063a7ddd4abea400e29c8b3edf3858136"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "mvfst"
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
