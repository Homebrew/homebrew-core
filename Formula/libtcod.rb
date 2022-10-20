class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/1.22.3.tar.gz"
  sha256 "a6f05f009db1f468338cf4cf984245a869ebb197b6d2524a8369c22ff9f1b9f5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c67d0c383ddd1d295868fb89e0151efe480288adde3e6524421b52f84e903cd6"
    sha256 cellar: :any,                 arm64_big_sur:  "2f13f66cb9f9db4f46e44fdf2c39c45fa9a4430d87f4e2d1b18cf72b9f2c4284"
    sha256 cellar: :any,                 monterey:       "068f20ec5903fb688f08f58269de93731df9e274009abaa6b95f585c46f59acf"
    sha256 cellar: :any,                 big_sur:        "00dd7c29d120ed771a0a2fac7fdec86c950cbfb4414c6510f1f9752456d5d65e"
    sha256 cellar: :any,                 catalina:       "569ab7f045b21bffefda4b751b0f7cbb1c7b3dcb230a4f076880e2e4ab982c82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d2b12d79d8429e87c6140f71abfedca5f6cdbc379927f945954dae5e70367e4"
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
