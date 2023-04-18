class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/1.23.1.tar.gz"
  sha256 "dd00be7dde66aa7456bab8acf98b6a0ae73871bd5bee10a7838752fdd7007c6e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4d3d7be32377aa333d1e5352f28ace0d5985ebb0a2f95910e18553deb206463b"
    sha256 cellar: :any,                 arm64_monterey: "d7777853052eee7141bdf456a8be5e96b2065d7f50c9b948a3f307c00f2c1f37"
    sha256 cellar: :any,                 arm64_big_sur:  "1dd1c1908bc001d8d3fc6148b841bf64f774d49cecd84f99a59d5b5df8359abd"
    sha256 cellar: :any,                 ventura:        "6e01727ebeac536f92ce375cc2a51aff1309e901ebe84b5d03558d61686bb3b6"
    sha256 cellar: :any,                 monterey:       "375b0bd3b779a058256c33c65a84b94a035b038ce6e49a8030a27e6162e858e6"
    sha256 cellar: :any,                 big_sur:        "ec1a87e97f42dabad818aa501b92a94df612eed7f7e20380a4a806a69ad25c82"
    sha256 cellar: :any,                 catalina:       "8827b6154dbdf32f0806390d613321de3126dc89658cbc9a1fe0e3a45a5c5bf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c481d057b749803c27882166d1e66c5877aef2f80cf5c38c18e6afed900287a7"
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
