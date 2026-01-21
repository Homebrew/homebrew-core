class NativefiledialogExtended < Formula
  desc "Native file dialog library with C and C++ bindings"
  homepage "https://github.com/btzy/nativefiledialog-extended"
  url "https://github.com/btzy/nativefiledialog-extended/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "2fea19102cf4d5283a80fb87a784792166988e85bb92baa962d34f72b22dcc1a"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a1183c71f2f72655aa54a7ed4031954fdb9a7b346c8ac27cc01d2d74419e481c"
    sha256 cellar: :any,                 arm64_sequoia: "65a2aa7061b67d6e18055f3beb5269bbb80b52e201d48d7d7ac7cf504b4d2ac3"
    sha256 cellar: :any,                 arm64_sonoma:  "ca6472d511ece4fc9e6f082f566c2cfa89032bb2b8f42442c3c8c587ed6c5394"
    sha256 cellar: :any,                 sonoma:        "13ff4a381d5222689b00379c4953ff4de3ef00ab1a6ed107c51e2e6360c99b07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51dc0d5a51585b3abe21d9e45a9a913ef38b6de85f7fc89417ad7cf10434c341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78ba8588b6b519f5ae687b156c556c5951c7ae59cea47d70cc3021e0f9555673"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
    depends_on "gtk+3"
  end

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DNFD_BUILD_TESTS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <nfd.h>
      #include <stdio.h>
      #include <stdlib.h>

      int main(void) {
        NFD_Init();

        nfdu8char_t *outPath;
        nfdu8filteritem_t filters[2] = { { "Source code", "c,cpp,cc" }, { "Headers", "h,hpp" } };
        nfdopendialogu8args_t args = {0};
        args.filterList = filters;
        args.filterCount = 2;

        NFD_Quit();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lnfd"
    system "./test"
  end
end
