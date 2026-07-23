class Libunicode < Formula
  desc "Modern C++20 Unicode library"
  homepage "https://github.com/contour-terminal/libunicode"
  url "https://github.com/contour-terminal/libunicode/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "df2c7b1a80e7aeb52f0ac3e23e460d4b2ada3996307dd886aca8e058d3ddb653"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6a004365d09fdd84821adae605ce2cdab34191f9ba15c24129be6c165bd8d83a"
    sha256 cellar: :any, arm64_sequoia: "7520c9260f8418cddbbd607faae1e7d495ae0f7f589d535b9d420df8749057f3"
    sha256 cellar: :any, arm64_sonoma:  "8caa65b506f6b61e26910c1b440597c8f204f7f43efc76bd2d0d2fbf3bf1e330"
    sha256 cellar: :any, sonoma:        "1bee7294260e85f3b1b1e417ffadff9aa5ef5fe119108b2666ab33bbe6db96e9"
    sha256 cellar: :any, arm64_linux:   "eb32d01acce5e6db66f0c4c34d7c3b979505c047808be01854cb748b75c43d84"
    sha256 cellar: :any, x86_64_linux:  "3dc8d5469e096427e75f7e5c34046a897a7bacdd6444bd98c5ad656637078524"
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
