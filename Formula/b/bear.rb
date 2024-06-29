class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.4.tar.gz"
  sha256 "a1105023795b3e1b9abc29c088cdec5464cc9f3b640b5078dc90a505498da5ff"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "6c92681f8750f45773633454f7b8e68f03ad9e81141494f348fc960342705859"
    sha256 arm64_ventura:  "f5aafb0ebf2c3ffad2fa1cfe7715d1dc18a0fe45d3dec2b40805bdf51d1fc7bc"
    sha256 arm64_monterey: "a9c5d8508db3139735b69e762de15acf29951bb27876dfd243eb1047fa9210d2"
    sha256 sonoma:         "7614d4bde126dd2b8bf2e0ee1474cd364630cc29a60f1f8c9e31b129daf78ab5"
    sha256 ventura:        "4b548093957f8818ede3b9d77bef31655f25442066663f615036bc9765b4a4c0"
    sha256 monterey:       "9ded627c624da6dd3e77c380a82345673ca21f428dffbdeb5cba5d6f8ea5a0ba"
    sha256 x86_64_linux:   "9f3fc48220a6ac4d8b9cb38d91bb5bbd8ffe3147cc9de3985626f1cba6994885"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
