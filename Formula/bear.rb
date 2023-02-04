class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.1.1.tar.gz"
  sha256 "52f8ee68ee490e5f2714eebad9e1288e89c82b9fd7bf756f600cff03de63a119"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "d0d3c23f3823f1c40f7fadd5d0ca596007a392b59a52fbf35c4af734e01934d2"
    sha256 arm64_monterey: "8b01bc8d9e431ad71e4a667f9c51d2711257a02442a8070db308c5fc925e3e51"
    sha256 arm64_big_sur:  "4bea459179bf5e61b668d3aeac58b30940fc07bfa2f8ea857382cfc66eaaf183"
    sha256 ventura:        "e04ffc67e6b9cd1a2f0bceea1d80a89de68be618b3645c31c74f3d8304d5afdf"
    sha256 monterey:       "8715121ee27e85d59a71dee9c9b08f10474051fe399a9380315b2a2d3028483d"
    sha256 big_sur:        "e5a0667606f8c81aada3efe8b071c9d745e87b4b0a89841e0940cffc9c7bc39e"
    sha256 x86_64_linux:   "d99ddfff4ef147053da6b1cc8fb4d04d62df451a9511c18ecbe276021e4f856a"
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
