class Cpptrace < Formula
  desc "Simple, portable, and self-contained stacktrace library for C++11 and newer"
  homepage "https://github.com/jeremy-rifkin/cpptrace"
  url "https://github.com/jeremy-rifkin/cpptrace/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "5c9f5b301e903714a4d01f1057b9543fa540f7bfcc5e3f8bd1748e652e24f9ea"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "714c67c234ab6bd2171290fd8d6738e1a79baf2ac93f3fb9ddcba22f510b8492"
    sha256 cellar: :any,                 arm64_sequoia: "1e2015f8f8175f025a2afef193c218f2bcf6491a597b3a24383680cd608511d2"
    sha256 cellar: :any,                 arm64_sonoma:  "ca98f143e04d55612619460edaec82fc6645d9ee938efe0ed63fc988a7acea2a"
    sha256 cellar: :any,                 sonoma:        "6c3fa5f1410a4005238b36afa5c1e444f8e8716b540731dec1092a1a70dad5e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "425e59efde03a6d782b628dda04c279f8d889e77af26cedf375dfb036c860c0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14595a27d917a2b8d41000b814f5db6dfcadec7b7a0b6a6c3ecd5ac020114e3e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "dwarfutils"
  depends_on "zstd"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCPPTRACE_DEMANGLE_WITH_CXXABI=ON
      -DCPPTRACE_FIND_LIBDWARF_WITH_PKGCONFIG=ON
      -DCPPTRACE_GET_SYMBOLS_WITH_LIBDWARF=ON
      -DCPPTRACE_UNWIND_WITH_EXECINFO=ON
      -DCPPTRACE_USE_EXTERNAL_GTEST=ON
      -DCPPTRACE_USE_EXTERNAL_LIBDWARF=ON
      -DCPPTRACE_USE_EXTERNAL_ZSTD=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <cpptrace/cpptrace.hpp>

      int main() {
        cpptrace::generate_trace().print();
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-o", "test", "-lcpptrace"
    system "./test"
  end
end
