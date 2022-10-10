class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.10.10.00.tar.gz"
  sha256 "78a4aabe4e53a5d7870f3f4bf0a70c009d2d0e470083552f232830866fb76134"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c5ad216c7f8f603aa87d1cc78d5d0b90ac2b10a9581fb7ff65b6e7f50bc2f260"
    sha256 cellar: :any,                 arm64_big_sur:  "0a8db139c18ecc47a4e3eff3a7fa97464085275e40fc20641b2fd8604ae9eab9"
    sha256 cellar: :any,                 monterey:       "32977a7a9420533f6de58dd1734e9e42a5aba22d624bff5357d6516b3c4ab604"
    sha256 cellar: :any,                 big_sur:        "7deb5317c31e210f11289b62b60b4b665b0f8b63a22d3cba6eb391aa2bc8e461"
    sha256 cellar: :any,                 catalina:       "53da74bfbcfad1b4c4c7e64c583bd69100cf509e2852ed442ea9ba0af3fdd340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84d906b71105d4be3015c9a3d5a5ec4b01d80bbe277b85b6a93810a9a164af70"
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
