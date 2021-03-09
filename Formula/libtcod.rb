class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/1.16.6.tar.gz"
  sha256 "7f55579f163ad48ce05bc9f7a7597bf2bcf8449f5249b49d45567d7e2940ab29"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0770edf9bc3a7596f90d4cc154e164b18a2ba35ffdbdefab82c57d41c9df5bb3"
    sha256 cellar: :any, big_sur:       "ae925c1b758d1f1b7b7a00709c6bb32107f81af13a6ba947c187737290eebae1"
    sha256 cellar: :any, catalina:      "b8ba426399d67c23880e2657e2c8ddd69b9e4e48f51ddbf708a3b8b3bc23c997"
    sha256 cellar: :any, mojave:        "afdc4240c571e2c34e33b59b6506ef0705a7b69b75f5fee899a2e37c247c4cfe"
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
