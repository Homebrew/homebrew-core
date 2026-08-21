class Libunicode < Formula
  desc "Modern C++20 Unicode library"
  homepage "https://github.com/contour-terminal/libunicode"
  url "https://github.com/contour-terminal/libunicode/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "78b715bc2d929530bc89e47c1c6772b72f511e1831b14e7d6d92cceb62592920"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d87a815a68fa968eb1bb053fe6b1fdf2833cdd290fd0ff3e9609be7f29336a26"
    sha256 cellar: :any, arm64_sequoia: "547e9d97ee56e3f0da1649bc84dd7436eaa739177c84c2f7c8ee1fd1ee589952"
    sha256 cellar: :any, arm64_sonoma:  "0908f43adef9b8bed573686cb5365f47b2a42226578ce33cf201db6a043f5036"
    sha256 cellar: :any, sonoma:        "7546d637544f4e2857c54536dbba50f95a1eb32aee4b57b352db353870a3f1d1"
    sha256 cellar: :any, arm64_linux:   "a372501aa4e4cbef8dc2cfeface7c4ee3cdca87394ede7df56603fd8dd0b8d0e"
    sha256 cellar: :any, x86_64_linux:  "562aeadd971b66d0a063e4cbf4740e52b8bde3ac93a00c0a6c9e600cbf078e91"
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
