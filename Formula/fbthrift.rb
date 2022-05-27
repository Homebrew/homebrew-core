class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.05.23.00.tar.gz"
  sha256 "a8dc404333e8b34e623c9e823306eaabbcd5ef571b4ca3835b755c07d29c6061"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9d43b1a9a9bc2403a054cccf9b2ac150bb9481607beeaee285dab5e4feadfabf"
    sha256 cellar: :any,                 arm64_big_sur:  "0f165329de0341c6bac949a0c2b660a1c65068ff003f0dfe83335a3b1fe72f08"
    sha256 cellar: :any,                 monterey:       "970459281f31fad7c9295d5f7d828628ca8248673afc3ee9579f0b36a4867e87"
    sha256 cellar: :any,                 big_sur:        "09635f364183f07489413e9189fb29998e993556456e819beeea7093fc96b032"
    sha256 cellar: :any,                 catalina:       "560d580a54a274be4f583d1bbb620b435d51761392e4218e4b2ba250a93c8bd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d57278ac7db7f5c22d21d178560ac9e9764fb5d5b92a8a6ed21468b88314ee3"
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

  # Fix build failure on Catalina.
  # https://github.com/facebook/fbthrift/pull/500
  patch do
    url "https://github.com/facebook/fbthrift/commit/eb566ef3fd748c04ecd6058351644edee0d02dbf.patch?full_index=1"
    sha256 "12286a10e3802e15ea03ea4853edd8640f9e5aedcac662b324a708625348a809"
  end

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
