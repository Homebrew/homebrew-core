class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/refs/tags/2.2.1.tar.gz"
  sha256 "5eb8e30d937840986c11c7baa22ffa93252aa4ac1824fe2c5fa1d760b3496a8e"
  license all_of: [
    "BSD-3-Clause",
    "Zlib", # src/vendor/lodepng.c
    { all_of: ["MIT", "Unicode-DFS-2015"] }, # src/vendor/utf8proc/utf8proc.c
    { any_of: ["MIT", "Unlicense"] }, # src/vendor/stb_truetype.h
  ]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9b74aebec81d3ccba2c7272f3041b8336601c84d8e5769a9210b478f4ad4a527"
    sha256 cellar: :any,                 arm64_sequoia: "9204636d7c64daf224117866ea8b740a85b47e99bc2acb50e824e75fc6d420f1"
    sha256 cellar: :any,                 arm64_sonoma:  "e6413d51dc366f870b92bc423a06b0d723425d344302c13acdf841bde807b4b0"
    sha256 cellar: :any,                 arm64_ventura: "d95b990a8dd6007006c88586e34a22945caaf30958c56f728d5cc6e135598055"
    sha256 cellar: :any,                 sonoma:        "60136c98d9a40fb59ea7dd6c85cdf22931a992931dc1485bf93a1b0394610104"
    sha256 cellar: :any,                 ventura:       "360ef3e725a8f627ca0d071f752cabbd63e6c9dd48381f55ad2ea30df9412f9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da2ab505637a97abd3cc2e6451764cd25d7c753652c72f7e6eac05c2c6da1c45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff4a6678933d2be5dd6d4a525ecd2695f513db4e2993d7bea439ead2e8d2bf14"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sdl3"

  uses_from_macos "zlib"

  # TODO: Remove in syntax-only PR
  conflicts_with "libzip", because: "libtcod and libzip install a `zip.h` header"

  def install
    rm_r("src/vendor/zlib")

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_INCLUDEDIR=#{include}",
                    "-DCMAKE_TOOLCHAIN_FILE=",
                    "-DLIBTCOD_LODEPNG=vendored",
                    "-DLIBTCOD_STB=vendored",
                    "-DLIBTCOD_UTF8PROC=vendored", # https://github.com/JuliaStrings/utf8proc/pull/260
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"version-c.c").write <<~C
      #include <libtcod/libtcod.h>
      #include <stdio.h>
      int main()
      {
        puts(TCOD_STRVERSION);
        return 0;
      }
    C
    system ENV.cc, "-I#{include}", "-L#{lib}", "-ltcod", "version-c.c", "-o", "version-c"
    assert_equal version.to_s, shell_output("./version-c").strip
    (testpath/"version-cc.cc").write <<~CPP
      #include <libtcod/libtcod.hpp>
      #include <iostream>
      int main()
      {
        std::cout << TCOD_STRVERSION << std::endl;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "-I#{include}", "-L#{lib}", "-ltcod", "version-cc.cc", "-o", "version-cc"
    assert_equal version.to_s, shell_output("./version-cc").strip
  end
end
