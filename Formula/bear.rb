class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.20.tar.gz"
  sha256 "45cfcdab07f824f6c06c9776701156f7a04b23eadd25ecbc88c188789a447cc7"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "935c62b5a9eba18081281b42e32a708a265c631646215b16c410ea2ad301d796"
    sha256 arm64_big_sur:  "ff43f8af2f3e15b0b813f98a3339611c0fb21fce04ad402c5737f8ff4d17ee5a"
    sha256 monterey:       "b7314d2ad398e843d0ea540d166a4fea3278c0049cb736dc3a2a304fdbafb049"
    sha256 big_sur:        "d72ca5a519b53465e0eaaed098256fd40aaae9d68267cdf8a15e94764b7416c8"
    sha256 catalina:       "2cb2540a175690cceafe7b278e05cdb60a5315b1895f065a0d0afb4faf4d3236"
    sha256 x86_64_linux:   "7ab5600fda83ded19d93296a67238019e2275422b51200d89cfd29be988f7999"
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
