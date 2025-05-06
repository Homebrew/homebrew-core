class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/refs/tags/2.1.1.tar.gz"
  sha256 "ee9cc60140f480f72cb2321d5aa50beeaa829b0a4a651e8a37e2ba938ea23caa"
  license all_of: [
    "BSD-3-Clause",
    "Zlib", # src/vendor/lodepng.c
    { all_of: ["MIT", "Unicode-DFS-2015"] }, # src/vendor/utf8proc/utf8proc.c
    { any_of: ["MIT", "Unlicense"] }, # src/vendor/stb_truetype.h
  ]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fdf83b0198f348818e794ebc1e0d4532f8c1cce635984534ebdc4891f4261aa0"
    sha256 cellar: :any,                 arm64_sonoma:  "2a4da5bd870a27621a99008356229ae7df8779e78f8ea2112651a6d4aca31445"
    sha256 cellar: :any,                 arm64_ventura: "bf4af16caa91fcecc6dcd450ab6cf68139b57ee8a96291b735dcb36b8ffc3faa"
    sha256 cellar: :any,                 sonoma:        "99781dbb6dbec408f03c3d3888de89de02b5ca42faa618733a2c7b660a1cfb98"
    sha256 cellar: :any,                 ventura:       "d22d6cdeeff35bebf79fdc25345c6f7ff9629204c16d134752b4a91ee24a2675"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5f5046d6639c7e7346615716f24ac569699677e53189afdfd6a0758807fedfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3f044b5650066da7fe44f464408690061b7b245a29ec818ebaedb6e85a25d8b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on macos: :catalina
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
