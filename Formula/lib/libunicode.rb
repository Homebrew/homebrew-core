class Libunicode < Formula
  desc "Modern C++20 Unicode library"
  homepage "https://github.com/contour-terminal/libunicode"
  url "https://github.com/contour-terminal/libunicode/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "aa6bc519712c541649553096c2b722c39a3ede765b9dc2d103012f1f90bec331"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d2f1804a670d8cf22d7ca18f3aea22125b302989fc84c6d55b46b946776ee1a9"
    sha256 cellar: :any, arm64_tahoe:       "18a27e993661d55652d7ad6cd77659a24529ccbfe187e638edc6458d0a81ea2a"
    sha256 cellar: :any, arm64_sequoia:     "3d31cf9950c1cd2c49405ed6429c6a164189ae6bff1feb4755b8066a256e6228"
    sha256 cellar: :any, arm64_linux:       "961fdaf3a50a42d6e11729608ca9c665d4b061ca1dec9cbd2fe1eef671d4a7f7"
    sha256 cellar: :any, x86_64_linux:      "39bdc083f2b2118dddfadcb0ff3ee72f05e61602d4a5581c36d7d64af63f829a"
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
