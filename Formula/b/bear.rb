class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.5.tar.gz"
  sha256 "4ac7b041222dcfc7231c6570d5bd76c39eaeda7a075ee2385b84256e7d659733"
  license "GPL-3.0-or-later"
  revision 12
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "12bb708e6f4188c2a04ed50070d7180c80a2ab2e7e013d8a44dc77986d7734ce"
    sha256 arm64_sonoma:  "a89003203140dc1c69931f742ee57cd2c6213438f789c6f009159ddd9d8e4777"
    sha256 arm64_ventura: "6e531bd29115bf118a01319758c2ef1c4310c9464da9924f6fddaed9f687155a"
    sha256 sonoma:        "5bdde65cbd80c380f2fd8696f24d3709be23907b43279d3ba0a988a8a6fcc2a7"
    sha256 ventura:       "d9888e92140d9152b9225756dbd6b025a914d4bb5167c67823829b50c9c753dd"
    sha256 x86_64_linux:  "c03da50aead875eb0d6b5843936e94d54769bf32c891a92c6640b4e623b46ee4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "fmt"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "protobuf"
  depends_on "spdlog"

  uses_from_macos "llvm" => :test

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
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
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    C
    system bin/"bear", "--", "clang", "test.c"
    assert_path_exists testpath/"compile_commands.json"
  end
end
