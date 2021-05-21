class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/1.18.1.tar.gz"
  sha256 "6bced6115bc764c0465db96e3553662ae6dc2f9358c5499a1984758a841f8ec7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f33e2d10dd53d5460b5d80703e3174874b30f49bf638db1a42de613d58b54df6"
    sha256 cellar: :any, big_sur:       "65b051955f173b506ef74ba7c5f817cb730df40d1a1e6f7b8d22227346c179d1"
    sha256 cellar: :any, catalina:      "fed7905968d43964c27057e2747858ecaa66cf8d2732e3180f992893de301f9b"
    sha256 cellar: :any, mojave:        "7612631b81cea78c96528302c4badb10e6470a90220facd79a1adfb26735e903"
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
