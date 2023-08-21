class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/1.24.0.tar.gz"
  sha256 "13e7ed49f91b897ac637e29295df8eeac24e284fbd9129bb09fd05dba0dcc1fb"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "11aa13a704fa606a3f6d35d0b98fdf0a129d074245a17bc5daf4f24ac076c6f4"
    sha256 cellar: :any,                 arm64_monterey: "e1d65ee49d8e100b6fe47c86fcaeacf1a5d6dd38a946ac622381e4d91bd5fbbf"
    sha256 cellar: :any,                 arm64_big_sur:  "34e498bbd75753bda91543a8a252f2866a93e443b72a345115cc5ac4c2bcc01d"
    sha256 cellar: :any,                 ventura:        "24d540df6308f5b9257c8f5d4709baa942d07e734085c7bad5642a7728d2ef19"
    sha256 cellar: :any,                 monterey:       "b7c1bee7957509545be34d6f81d911806cf8e345ca8312553a0c977ee11812fd"
    sha256 cellar: :any,                 big_sur:        "57585379fc42bea09b2d9bf429892dc61705f8bb32629297e384e1168103bcb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10da3d61a23ba6008918b74ad416c4ee85242c74819c75be8be09401d7903d07"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
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
