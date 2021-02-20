class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/1.16.0.tar.gz"
  sha256 "05cef28abb8e784a7395f2d19a29c346b8ef3d9f6fa7b86e11554ce25306d1d0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "91e3bd372b0d6443963d2009fc694f6520f9a9de4ef45f6d18f3f00e65de9fb8"
    sha256 cellar: :any, big_sur:       "31bfe926a2effb964e4653a12a321f6bb3bd3ed0e05c63c5509442a8518bc150"
    sha256 cellar: :any, catalina:      "c0855fddcf47a6ca4b544f34993913480953705c7c1764c4a7fe3ce4c1d74b5d"
    sha256 cellar: :any, mojave:        "b2c376538851cfe1f09fbe4700961d23dbf9da6572f43e57b6aae67f8ffef931"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "sdl2"

  def install
    cd "buildsys/autotools" do
      system "autoreconf", "-fiv"
      system "./configure"
      system "make"
      lib.install Dir[".libs/*{.a,.dylib}"]
    end
    Dir.chdir("src") do
      Dir.glob("libtcod/**/*.{h,hpp}") do |f|
        (include/File.dirname(f)).install f
      end
    end
    # don't yet know what this is for
    libexec.install "data"
  end

  test do
    (testpath/"version-c.c").write <<~EOS
      #include <libtcod/libtcod.h>
      #include <stdio.h>
      int main()
      {
        puts(TCOD_STRVERSION);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-ltcod", "version-c.c", "-o", "version-c"
    assert_equal "#{version}\n", `./version-c`
    (testpath/"version-cc.cc").write <<~EOS
      #include <libtcod/libtcod.hpp>
      #include <iostream>
      int main()
      {
        std::cout << TCOD_STRVERSION << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "-I#{include}", "-L#{lib}", "-ltcod", "version-cc.cc", "-o", "version-cc"
    assert_equal "#{version}\n", `./version-cc`
  end
end
