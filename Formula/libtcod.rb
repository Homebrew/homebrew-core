class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/1.16.6.tar.gz"
  sha256 "7f55579f163ad48ce05bc9f7a7597bf2bcf8449f5249b49d45567d7e2940ab29"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "15e3f3869592801d485bdd6d24a000b6ee1626f12c17174445c79e99c9d65468"
    sha256 cellar: :any, big_sur:       "732c3730722eca5081c942961bfa7cdc481d57d12eb2c4c1ff9a32678950c9d6"
    sha256 cellar: :any, catalina:      "7bafd58f97c5a6bf12b34ae9951610f77891b5d9aaab9bdd324aef95cf83c6d6"
    sha256 cellar: :any, mojave:        "92b45c3ba47915fb4a04d4e10849f8099ed72a90b05e760637aed6369e2f638e"
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
