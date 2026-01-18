class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/refs/tags/2.2.2.tar.gz"
  sha256 "69f30fe65df1c84049a8f4f4b1ea0894191221da3a671be61832e33e75df898e"
  license all_of: [
    "BSD-3-Clause",
    "Zlib", # src/vendor/lodepng.c
    { all_of: ["MIT", "Unicode-DFS-2015"] }, # src/vendor/utf8proc/utf8proc.c
    { any_of: ["MIT", "Unlicense"] }, # src/vendor/stb_truetype.h
  ]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3687d7b12bb271b81362baef090770acda1e6b7917e6321e0bae1dc3ac520e06"
    sha256 cellar: :any,                 arm64_sequoia: "c08ce55939f22ea91ce2a5f195e5cc8640c29ea4e75dae51773dfd86b78750c7"
    sha256 cellar: :any,                 arm64_sonoma:  "a696e891e5fc13f55b730c8c2e3c3a80d616fb0ec11cdfd7ffe3e74611b31bec"
    sha256 cellar: :any,                 sonoma:        "2d82f0ef65eb6bd3ae04ac29c6c58051d43339ba50ef40ff1d46dce2547b31c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0066f7f25b53c3ef0f386b63b11a04c1c15bdf804348f0f893c20b696b7ec89a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d02c1e93daa5f1c0d1256280caa89e53b4825949778e5567ee537d406709160b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sdl3"
  depends_on "utf8proc"

  uses_from_macos "zlib"

  def install
    rm_r("src/vendor/zlib")

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
