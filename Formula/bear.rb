class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.20.tar.gz"
  sha256 "45cfcdab07f824f6c06c9776701156f7a04b23eadd25ecbc88c188789a447cc7"
  license "GPL-3.0-or-later"
  revision 7
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "aa1b5209eb105bd971cc09abb04750b1ab4e0c2970b9f2185303d12cb09b8541"
    sha256 arm64_monterey: "101f9d25f59ee4bcd74de1d3457f965e660c3fcf2115b1ee995698f6f9a3a872"
    sha256 arm64_big_sur:  "4326a6ee84dbfe462fbb77730f54f7b9e5de33af507a493f7b22a72db7f55d6a"
    sha256 ventura:        "d5cf0431105e9fceef9e079521f4ebe7054f610e6c85f119d2a9f8bd147ec3f9"
    sha256 monterey:       "14b09d9f926bb3e9b7fbf8a0be2217c7f78c9051e5bd301db3c839d51807e50e"
    sha256 big_sur:        "87e639286fb4227eb72c2aedfd079a82383fb8b54b68e46a90e3dc08d4be1a78"
    sha256 catalina:       "94a12d1cc3b7946c4bf40e2736277686922492fd1563ddff8aab5609ef1550fe"
    sha256 x86_64_linux:   "b2792136b24c9d193611ce806af7163fed3ab952089119251f0a1792cbc61db8"
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
