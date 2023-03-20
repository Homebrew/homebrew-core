class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.1.1.tar.gz"
  sha256 "52f8ee68ee490e5f2714eebad9e1288e89c82b9fd7bf756f600cff03de63a119"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "0ce5a926327fb07e48533deac8d46bf715631090b0ff2019eaf3ecc26b617d36"
    sha256 arm64_monterey: "1f93e7b42fc1de65b2783b97d610bb1f746537da322f53bc34ea28a85297e4ff"
    sha256 arm64_big_sur:  "10db9c8ddd3d958e442c03b582b6b8c9538da0c7584254dda8ef5febb0c446ee"
    sha256 ventura:        "0e247e8e1e83a43ae251e107d474ed9ff22d103bd4f1692bcaf88d68f001b909"
    sha256 monterey:       "b2b439eeeabb2ae7efb6449de0c8ec6e488706e8fd233bc01e94333993bed859"
    sha256 big_sur:        "1af8d201342e2ff72d6980287ca07d6224b22902e215a60b505c737a9e879df7"
    sha256 x86_64_linux:   "45376b1a30f8bcba3f632715ab381cd18ac4be9ec9878453581ae4415b6dca72"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fmt"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "spdlog"

  uses_from_macos "llvm" => :test

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with gcc: "5" # needs C++17

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::__current_path(std::__1::error_code*)"
    EOS
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %w[
      -DENABLE_UNIT_TESTS=OFF
      -DENABLE_FUNC_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    EOS
    system bin/"bear", "--", "clang", "test.c"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
