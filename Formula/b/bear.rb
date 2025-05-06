class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.6.tar.gz"
  sha256 "99cd891eec6e89b734d7cafe0e623dd8c2f27d8cbf3ee9bc4807e69e5c8fb55c"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "d972c82724c1d6aeb3c7d345027fff6f46a39901eb91efe3caed45a476130987"
    sha256 arm64_sonoma:  "53abace5e60be878c36336a8524cf3dae8d2ca641ff724351efa07afa5f8012b"
    sha256 arm64_ventura: "00e58ae4430c5abc7fb8f8daf05e7e77f0f6a4fffd599d4b592864be7c09e4a4"
    sha256 sonoma:        "de0bbb65470f5b6481979ec3a885041e0ba07fbd88263bc391c3c7ca963f1dc6"
    sha256 ventura:       "210733da953a8fefca62c17e1a5e7af54aa9271d25ebe4bfbf2c3f582d1464a4"
    sha256 arm64_linux:   "f390959ee3aacdbf2ca776ca4a918f28b32fc096667e076818f8322a2def2468"
    sha256 x86_64_linux:  "6e8206f6f977d625d90225f9da4190c7c707726a1e9fa31efe1da485b8227e2f"
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
