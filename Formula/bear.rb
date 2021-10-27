class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.16.tar.gz"
  sha256 "877ee5e89e8445f74df95f2f3896597f04b86a4e5d0dbbca07ac71027dcb362d"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "303f97eac0a4a6f7139c1a75bdfbaf189d4d7956b3cd63ddc1c2007aefe6c751"
    sha256 arm64_big_sur:  "7654072a05b7af6ccdbc4d10b7f50cf2ba2be1edf9abb9d3324f5a4a2ef6ffee"
    sha256 monterey:       "cd9346b9eced253a283c4e6176ceaf929471e019fb2300fbe1fff456c049bd8b"
    sha256 big_sur:        "ff8b6a8fa026031a139c56941be5ea3148ee9eb5c860bdee4a8754992710e570"
    sha256 catalina:       "6b441b4b8f2d3da8fbc2c667c1f030dae34857f0ff4e0ac72cd24cacd8321232"
    sha256 mojave:         "810136143f4580e4b5538c05cbf17b9b86a368534aecac19513fcb139cc8fb32"
    sha256 x86_64_linux:   "39e65e249817a04308318f8d321940c36976542078fea6895fe959b866cbde35"
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
