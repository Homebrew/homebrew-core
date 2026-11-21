class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/refs/tags/2.3.3.tar.gz"
  sha256 "e42d67c9afac51d4ff45a7c35fc25b216ccd6a23897cd4dd21a4b2e0e2337277"
  license all_of: [
    "BSD-3-Clause",
    "Zlib", # src/vendor/lodepng.c
    { all_of: ["MIT", "Unicode-DFS-2015"] }, # src/vendor/utf8proc/utf8proc.c
    { any_of: ["MIT", "Unlicense"] }, # src/vendor/stb_truetype.h
  ]

  bottle do
    manifest_sha256 "a9e3d3f54a9fa3c7a1fda88632716983276ddcc9707594fa4e57cd7379b3eff0"
    sha256 cellar: :any, arm64_golden_gate: "9a33d37a211f886e81d8aa529a2bf810923f69d9c087900e021a53279556c1f2"
    sha256 cellar: :any, arm64_tahoe:       "6935b14317a6447ba8ba1abff168d57496cf1231d41ad2835f9e69e38ade3bc2"
    sha256 cellar: :any, arm64_sequoia:     "eaaf32bd1493e80316a77ff91e68ed92875625b8403fe280ba31ad84efd6bc56"
    sha256 cellar: :any, arm64_linux:       "07a3622c048c13f73b109f04b18336f94b928f21abe905083486291490311ec2"
    sha256 cellar: :any, x86_64_linux:      "d8e02aa078c5388312fc71e3a5977f533ee01673d652dbc6d81d2d582b8bdbb8"
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
