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
    rebuild 1
    sha256 cellar: :any,                 arm64_golden_gate: "6cf37b43575c9bbbcbac063453b9506b8be3a3c55d1bab912848df6922cd2a66"
    sha256 cellar: :any,                 arm64_tahoe:       "612e3f1e9f6976f652fbcf1a2eb61eea4fcc89587d7b53b15787b4397540da73"
    sha256 cellar: :any,                 arm64_sequoia:     "2936e52ddf2b7f8b348dd7c853b72151525639fa980e48db5321546887b8d472"
    sha256 cellar: :any,                 arm64_sonoma:      "2fb1ffcb63481f5bdd7ccbb37cc9ee5306893d6f081b80449066bab9b9259534"
    sha256 cellar: :any,                 sonoma:            "658e1e5d8b99476480480624806bc1f356064487dec25717193218d13564f1f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7061320d3e56653d9479caaaaf03cfc2a8ba93e3072afbf9a2edac0cd6852c81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9bd3c9f84e29286387f4741845a996b3fcecffec5ba6715842db8168f25249ee"
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
