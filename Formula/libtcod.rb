class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/1.22.3.tar.gz"
  sha256 "a6f05f009db1f468338cf4cf984245a869ebb197b6d2524a8369c22ff9f1b9f5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c605abec2c995c60ee9ca13c5fdec4c167257cf24c9fe6a2fbf9195b47e8928b"
    sha256 cellar: :any,                 arm64_big_sur:  "cd2d77c7c1904f9ed7aba1c6a6dadf945e10c5ca15bf691920eb8610283a6be0"
    sha256 cellar: :any,                 monterey:       "1ee5f17ffb63c30a5b9d593a0db5ec8ee0d7a18c75a5dd28af28ec367b8c05a1"
    sha256 cellar: :any,                 big_sur:        "5dce8ecf88a934d7ead445002509dc45c55c90a1745487590c2a294caa5126de"
    sha256 cellar: :any,                 catalina:       "58641b98b27edcbcc654c3d25a40e6fa23d37b78ee2fd4f608521ceb66c99cfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb78f54b7a97d26d8b18766fc58af18dd3f81612cf0130200ecea06f5d273e77"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on macos: :catalina
  depends_on "sdl2"

  conflicts_with "libzip", "minizip-ng", because: "libtcod, libzip and minizip-ng install a `zip.h` header"

  fails_with gcc: "5"

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
    assert_equal version.to_s, shell_output("./version-c").strip
    (testpath/"version-cc.cc").write <<~EOS
      #include <libtcod/libtcod.hpp>
      #include <iostream>
      int main()
      {
        std::cout << TCOD_STRVERSION << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "-I#{include}", "-L#{lib}", "-ltcod", "version-cc.cc", "-o", "version-cc"
    assert_equal version.to_s, shell_output("./version-cc").strip
  end
end
