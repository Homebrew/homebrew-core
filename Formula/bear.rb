class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.17.tar.gz"
  sha256 "107f94e045d930e88f5f5b4b484c8df1bf4834722943525765c271e0b5b34b78"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "af1aca0fb18ef80d1bacb47aee5efc52525c013cdbbac3547f0bd2e928a08e78"
    sha256 arm64_big_sur:  "99deda4c9a3a62b718e7780b7e9e4225e22b22bcbe6e04002463e16de343790b"
    sha256 monterey:       "ff4fa4a6376aece571dd9ae81e7253326e0aee0614a6a881f5c6d136866baf43"
    sha256 big_sur:        "571acc83a81ea3b3beb6e31fdcfae8666d57b174de4494893e762de6772e3f4d"
    sha256 catalina:       "0a4a24ae4486c8e888d5f27b3bf96fa8540c4766acf8d739bd061b388820d502"
    sha256 x86_64_linux:   "46af8de2e00478f0cfc9e01ee90a5ca0483bb94bbb1ff24ada843f67d1700a06"
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

  on_linux do
    depends_on "gcc"
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

    mkdir "build" do
      system "cmake", "..", *args, *std_cmake_args
      system "make", "all"
      system "make", "install"
    end
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
