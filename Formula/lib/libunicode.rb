class Libunicode < Formula
  desc "Modern C++20 Unicode library"
  homepage "https://github.com/contour-terminal/libunicode"
  url "https://github.com/contour-terminal/libunicode/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "65affc5decf38e5c3e104b021e6d696c2f5bf305f20b475604901682f137e02a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "96923a903c4727cd0981cb838046323df0d2387c79a25d4168dbc41cd21c980e"
    sha256 cellar: :any,                 arm64_sequoia: "64eaf35131519b22d28be7a936fe9c6c5819004d2e996236af0bb84ce77eae03"
    sha256 cellar: :any,                 arm64_sonoma:  "502a5dde6335ff9655503fc4050089880255a3929874dbf7bf3a6f9e3290985d"
    sha256 cellar: :any,                 sonoma:        "2366882adc5714fd78db3068a72a17c55c938925f39439e90c2889c32ac8e6c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f600c3d79303271fa845b4c79718a85c49c130d3da5b271b1a620e553f0ba96f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1feb81594418e9764f9e612a504f5a97a3df8363c9a101fc1d8ad5fa6648bc68"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1500
  end

  on_linux do
    depends_on "gcc" # TODO: remove and rebuild bottle on Ubuntu 24.04
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
