class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.5.tar.gz"
  sha256 "4ac7b041222dcfc7231c6570d5bd76c39eaeda7a075ee2385b84256e7d659733"
  license "GPL-3.0-or-later"
  revision 8
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "fc83be75f4c5ebfc4cc686a171e6b8842249d184aa1b72000f215f5bc906ae86"
    sha256 arm64_sonoma:  "a82d0bf2a8031776ca30daae21dc62cfc6244fd1234c2fec35bc3724fcfa449a"
    sha256 arm64_ventura: "33f3002ae81736ba0b951eeea73c011b6910f8c9cc10c09de989ccc43541a16d"
    sha256 sonoma:        "29a4f02339d5ed171ab9636f3e28e5eb89b456386f843e812d348e4a9e609a5f"
    sha256 ventura:       "d73eaf5eb1610ce116ecb0eafa54a78fd369cee7c1016b03ad778297d9ae5f06"
    sha256 x86_64_linux:  "4c65e36e547b6cd48afea84e86ff8b0243227609d66f2e3c42c7dfffd9f9190c"
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
