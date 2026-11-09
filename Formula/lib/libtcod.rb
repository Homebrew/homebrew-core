class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/refs/tags/2.3.0.tar.gz"
  sha256 "a14fdb3f5f0d2baab8a8d2ccd1819e4f757bc3181203f6e12890efffe0c072ef"
  license all_of: [
    "BSD-3-Clause",
    "Zlib", # src/vendor/lodepng.c
    { all_of: ["MIT", "Unicode-DFS-2015"] }, # src/vendor/utf8proc/utf8proc.c
    { any_of: ["MIT", "Unlicense"] }, # src/vendor/stb_truetype.h
  ]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ee037c1f7288a33f943ad07a0cb5c94a642e0beab6bdbd49680183ba3c80c586"
    sha256 cellar: :any, arm64_tahoe:       "05b2b3708b72eab1dff670bc08841912d8833b0a20272967d68ec7c984b76d00"
    sha256 cellar: :any, arm64_sequoia:     "32f8d79c69d20e1445d4f4d21a1510718c6a2dbc934ca879e6cd01df15948e59"
    sha256 cellar: :any, arm64_linux:       "5e137c1424f92303e51ea657d1191bae2c320a14790855d8ba60858b31adde9a"
    sha256 cellar: :any, x86_64_linux:      "72e2ae467e8e944fc1e7fbaead9388855ed20413e562da0ad2c8e6854232d658"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sdl3"
  depends_on "utf8proc"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix build failure when using `vendored` deps
  patch do
    url "https://github.com/libtcod/libtcod/commit/0c96fb729b0c787966e4f1edf3ad0dc095f653f6.patch?full_index=1"
    sha256 "a4fc5863843f55f442fcb772ef2a0d34fd586619a865268c8e791764cb64402d"
    type :unofficial
    resolves "https://github.com/libtcod/libtcod/pull/206"
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
