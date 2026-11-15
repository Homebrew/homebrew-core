class Libunicode < Formula
  desc "Modern C++20 Unicode library"
  homepage "https://github.com/contour-terminal/libunicode"
  url "https://github.com/contour-terminal/libunicode/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "7c619227c9866ee90c6443a7382df11306619a00c561a76b0a973882bc7b82e2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c36eef01f17313f2c9daa223b25093031e0ec9f35f4b67b79007861a691762fa"
    sha256 cellar: :any, arm64_tahoe:       "279e3ccddfa2ba7e14d30f54034cc52949fb9f4da6ab0f4711bce7e289ad4d15"
    sha256 cellar: :any, arm64_sequoia:     "7f8c00ea732c7c1bd629f0d50d78b6dcc3b10de66bfe8332734c9e9510916a40"
    sha256 cellar: :any, arm64_linux:       "8698f0fa266f2977de20b6d96038affcaf2b72a96ce3e3ed594a216a888144a7"
    sha256 cellar: :any, x86_64_linux:      "1a15a6cd1ef8a0afdc162035e861db112a0f09eee0788bfa78ba619ded7c1023"
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
