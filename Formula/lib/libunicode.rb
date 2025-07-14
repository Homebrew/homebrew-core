class Libunicode < Formula
  desc "Modern C++20 Unicode library"
  homepage "https://github.com/contour-terminal/libunicode"
  url "https://github.com/contour-terminal/libunicode/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "0c217f8264000f1b8c36e78969cb9cf91ac97de937cc141ab78e6b1ad7f404ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2e51dbe77f5b2853092a3648b1d22422b011641e893a56aafaf842d93e2ac75a"
    sha256 cellar: :any,                 arm64_sonoma:  "4543c2694bb3bc240a45792de40e9ecef4229eeed3ff73f25dea245c0aaa7fa8"
    sha256 cellar: :any,                 arm64_ventura: "dcbad1aeabc61e9e4ef5b0776cc40fcaab878e67931bf0b057847e3e9e69e86c"
    sha256 cellar: :any,                 sonoma:        "eb839f56e6eb0d2d877a623eeab2ba46fa4a2f8e7c5b6133232caef634f14fb8"
    sha256 cellar: :any,                 ventura:       "88b268f809736144bc316d83d38ece5c25c96c4b97b563173a8ca925fccddbc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dd8a8d2af9689cf2b7e45dfc7ac13ffd68cf9926041c787943c6d6d5f26ffd5"
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
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1500

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
    # ENV.llvm_clang doesn't work in the test block
    ENV["CXX"] = Formula["llvm"].opt_bin/"clang++" if OS.mac? && DevelopmentTools.clang_build_version <= 1500

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

    system ENV.cxx, "-std=c++17", "-o", "test", "test.cpp", "-I#{include}", "-L#{lib}", "-lunicode"
    assert_match "Grapheme cluster count: 7", shell_output("./test")

    assert_match "HYPHEN", shell_output("#{bin}/unicode-query U+2D")
  end
end
