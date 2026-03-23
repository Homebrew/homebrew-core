class Libunicode < Formula
  desc "Modern C++20 Unicode library"
  homepage "https://github.com/contour-terminal/libunicode"
  url "https://github.com/contour-terminal/libunicode/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "1cea0180dd75a46132505330218efc102152fc4eb52462e470ea2bebf836cc58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4846522bed2a20e0e55fc78d44bddfda8d20cc548e1ae52e11e2c515ab25497e"
    sha256 cellar: :any,                 arm64_sequoia: "18c77a62061164b2bb648f3c0d2f81c6dc59c6d55d203c630d4b4b76502cb50c"
    sha256 cellar: :any,                 arm64_sonoma:  "2c6d41deab236a258845bfe7cad0d1a23150b1c96ee5de45de133c342a993ef9"
    sha256 cellar: :any,                 sonoma:        "f425c312c6fc2946ae0cc20ee4bc69279c891c3f0c81036891ddc8ffe640bb8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5e2f93a5968bc3f0386cc34b9ab84188d71dcd9e6418bcee9c82f3ee5439ab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "875b32c339c1e465c6f2a1a1830b6d6e68b7a2a932638276c527088a395fb3dc"
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
