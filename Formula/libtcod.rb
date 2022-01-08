class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/1.20.1.tar.gz"
  sha256 "e36dccd1ad531503d1ceefe794a57b3b661e5e669c3d1db1d5bfaf0b95c933df"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_monterey: "da590ac1c9f351945ad478c0efae1f098ead33c746c9ff28db996cd42bf5036a"
    sha256 cellar: :any, arm64_big_sur:  "4a7ca2c373d350957262c89d7c162ea17392c8c85c6c17a03a9dc642c0a3fd7d"
    sha256 cellar: :any, monterey:       "83ba02b391451bd9f6ae1c925c3b3533de9292e01e85096d7e56ae21fef7703a"
    sha256 cellar: :any, big_sur:        "416ff19e729fd5e6a5408c8d481da89ade21e895dc57f15420ef5e2a30739bab"
    sha256 cellar: :any, catalina:       "1cc9df203a2b45ac83ecc22a7afc80bfac60b17bff331e065a73d81202ac026e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "sdl2"

  conflicts_with "libzip", "minizip-ng", because: "libtcod, libzip and minizip-ng install a `zip.h` header"

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
