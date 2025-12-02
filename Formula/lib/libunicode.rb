class Libunicode < Formula
  desc "Modern C++20 Unicode library"
  homepage "https://github.com/contour-terminal/libunicode"
  url "https://github.com/contour-terminal/libunicode/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "0c217f8264000f1b8c36e78969cb9cf91ac97de937cc141ab78e6b1ad7f404ef"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ea5fcaea62d8df857de80e1283e9e2ad9c76b0ba39c0c5ac4f067ee596dd8268"
    sha256 cellar: :any,                 arm64_sequoia: "b13740bd4f2da17cfd0671cacc40a0cc153c8965225a0e3333ab38b99f8bb48d"
    sha256 cellar: :any,                 arm64_sonoma:  "d03f19ed3d3d4397531d61d943f1eff14fa14762a496a2df7cfb23d0464b3ae5"
    sha256 cellar: :any,                 sonoma:        "b175e397353176dd09255afbb507fe39c57f51535edbb88209d481909abd46de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7870c39db0a6d6202c3a364be566608f2a235c1870291eefe0889bc8b50ac62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce22e0ecd71d651779c581de2301af8f86549af6125ce5fb05271968107d9c68"
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
