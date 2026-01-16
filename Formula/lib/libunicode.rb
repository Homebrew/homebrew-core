class Libunicode < Formula
  desc "Modern C++20 Unicode library"
  homepage "https://github.com/contour-terminal/libunicode"
  url "https://github.com/contour-terminal/libunicode/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "7b653d8cb3c620cc80118184ccab9c02f7e9a4bf9d1e4b190dae2d5681a0bca4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3cfe9a200d475b8174c7a0c1298475d489cb5b22cf349940158ed5e98762800d"
    sha256 cellar: :any,                 arm64_sequoia: "199133e52e16eda0ccefc0e56c65f1da3c3a5b576bcb43119f661779599f378d"
    sha256 cellar: :any,                 arm64_sonoma:  "32840c0a9239c1591156ddc4aa349d9770b9490265b50d427a3588b2cd8bb7e8"
    sha256 cellar: :any,                 sonoma:        "be2b2a44285d930b5403dc4477dbaebd57631adad0530a8a88c6c5b6e206851b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "067367069973c9b8daf39808818ea3ceb5b78fe06d25cb89368ae414c77b74cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a201de65e18aaa11df26e12693473d2c9d9d9ec00a45e8da20692cec99b7502"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1500
  end

  on_linux do
    depends_on "gcc" if DevelopmentTools.gcc_version < 13
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
