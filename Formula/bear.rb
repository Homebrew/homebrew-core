class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.18.tar.gz"
  sha256 "ae94047c79b4f48462b66981f66a67b6a833d75d4c40e7afead491b1865f1142"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "47abebae1cf258209d197e76a6fb8ce0edfeed0f01b821072f3491b59915d609"
    sha256 arm64_big_sur:  "c196537ebf6b8968cc41df1c07eefcbd2973964f80b5630e51b2376594e16deb"
    sha256 monterey:       "722e43d8b17699af3c0d56dbba76352e7dedbd6f526168151d2f7e63c7344201"
    sha256 big_sur:        "a09929d241011a491b564d62931f71cad4e6600869e24b3945f373dbef5f9317"
    sha256 catalina:       "e3555e6ddbdd3c966f041780e1b2dd97b7f18734fcdd68c962e691450a13615d"
    sha256 x86_64_linux:   "d1a99861791732f89f6642b8d86669d6edced638941672650b74bbe6f543ec56"
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
