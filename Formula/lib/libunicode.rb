class Libunicode < Formula
  desc "Modern C++20 Unicode library"
  homepage "https://github.com/contour-terminal/libunicode"
  url "https://github.com/contour-terminal/libunicode/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "65affc5decf38e5c3e104b021e6d696c2f5bf305f20b475604901682f137e02a"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "a59d7a6698079f276d08c20ad555efa2273a98e6407193618fa8e4495b859f87"
    sha256 cellar: :any, arm64_sequoia: "6aa720c62da5a654f1cb4faf4aafc0a66762742db9c098de751bf4e89bf04df2"
    sha256 cellar: :any, arm64_sonoma:  "545646dc6547e84c7890538748ff2cd3a40563370ac150f1aa7e11406f21df9e"
    sha256 cellar: :any, sonoma:        "de941d5e0f87e197c003dbaf6efbd852cd2b76a18e0282af3914c1688643b2d7"
    sha256 cellar: :any, arm64_linux:   "d6597137a777d6e9024a5987b816f1627b4cce071274f90b233b306c46022700"
    sha256 cellar: :any, x86_64_linux:  "d97e821272ea860ce785e7c650ba3f1224384ecc14c91c3df612f258220e978c"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1500
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "12"
    cause "Requires C++20 std::format, https://gcc.gnu.org/gcc-13/changes.html#libstdcxx"
  end

  def install
    args = %W[
      -DLIBUNICODE_EXAMPLES=OFF
      -DLIBUNICODE_TESTING=OFF
      -DLIBUNICODE_BENCHMARK=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <libunicode/capi.h>

      int main() {
          u32_char_t u32_codepoints[] = { 'h', 'e', 'l', 'l', 'o', ' ', 0x1F30D };
          int gc_count = u32_gc_count(u32_codepoints, 7);
          std::cout << "Grapheme cluster count: " << gc_count << "\\n";

          return 0;
      }
    CPP

    system ENV.cxx, "-std=c++20", "-o", "test", "test.cpp", "-I#{include}", "-L#{lib}", "-lunicode"
    assert_match "Grapheme cluster count: 7", shell_output("./test")

    assert_match "HYPHEN", shell_output("#{bin}/unicode-query U+2D")
  end
end
