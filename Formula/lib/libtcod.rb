class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/refs/tags/2.3.2.tar.gz"
  sha256 "a4f6bcdddd33fc3cdb52d47a269f0a22c5f88a15c855f596bb1e8e1698362173"
  license all_of: [
    "BSD-3-Clause",
    "Zlib", # src/vendor/lodepng.c
    { all_of: ["MIT", "Unicode-DFS-2015"] }, # src/vendor/utf8proc/utf8proc.c
    { any_of: ["MIT", "Unlicense"] }, # src/vendor/stb_truetype.h
  ]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e938472eaa920cfecf7f090c0e1ff2fd05407e362803713cb83ef2796e74a099"
    sha256 cellar: :any, arm64_tahoe:       "15c47925086e25619f041b169fdcf3f3654f9af6d9f456f68e15aee9035a71e5"
    sha256 cellar: :any, arm64_sequoia:     "69b316cb6050678054fd6aa77192944f4607683d9fc02361d5803329a89c4f67"
    sha256 cellar: :any, arm64_linux:       "7a2963d64bbdfee970affd45b507f1cdbd066d5cf5d87859d8164ff5a4b26dab"
    sha256 cellar: :any, x86_64_linux:      "bac5c893f7b2f114ad0880e714e1e21e7c385a72c31d5f23aca5d3727f52cd55"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sdl3"
  depends_on "utf8proc"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    rm_r Dir["src/vendor/{utf8croc,zlib}"]

    # We bypass brew's dependency provider to set `FETCHCONTENT_TRY_FIND_PACKAGE_MODE`
    # which redirects FetchContent_Declare() to find_package() and helps find our `sdl3`.
    # To re-block fetches, we use the not-recommended `FETCHCONTENT_FULLY_DISCONNECTED`.
    system "cmake", "-S", ".", "-B", "build",
                    "-DHOMEBREW_ALLOW_FETCHCONTENT=ON",
                    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON",
                    "-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_INCLUDEDIR=#{include}",
                    "-DLIBTCOD_LODEPNG=vendored",
                    "-DLIBTCOD_STB=vendored",
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
