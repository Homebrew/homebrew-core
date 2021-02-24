class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/1.16.1.tar.gz"
  sha256 "06bd0282182d8dd74c52520919d93b955cdd1a347298a4e6bb250d761f20857a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ba06f3dd667ff7fa42b0d371fbdfac6bccb6c92fc3dab0cfc7831880a53b17e4"
    sha256 cellar: :any, big_sur:       "7f98fcc75ff378df37d7585451395e835a87da246adeec1c30fb1fe451d65e9a"
    sha256 cellar: :any, catalina:      "c235b93eb4727f5305442c6391a8aaf63a6ab3d52bf8793fa9adde6ce0487c22"
    sha256 cellar: :any, mojave:        "d993800aa1dc0e254872564db202229119f4167ff2631b0eaf13d502f1c986cc"
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
