class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.5.tar.gz"
  sha256 "4ac7b041222dcfc7231c6570d5bd76c39eaeda7a075ee2385b84256e7d659733"
  license "GPL-3.0-or-later"
  revision 12
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "2b1b900012ef5b75b0f48b8bed7793e4447ba08d35a31d37aefeffeb463a8d9d"
    sha256 arm64_sonoma:  "37eaf4d18b0c57be5c55564cf6264a28b6337eb4e4cc9995ed1047bb5ee07c1c"
    sha256 arm64_ventura: "594c73d95643940c4eb0c26a0e249e07f535b39b62dc64706aab4572c4e85aff"
    sha256 sonoma:        "fa02c74ce394e74e703955dc82f9dadaa0dbe4cd890362af50e69cd899751655"
    sha256 ventura:       "86a1bbd39269086bac36c6a71f726cb38a86aae2e3bd731cebb7d2143fc4591b"
    sha256 x86_64_linux:  "f5044dbbc333e4cc00907610dcb67c6e3df3ca078591b437932393da7edbd9df"
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
