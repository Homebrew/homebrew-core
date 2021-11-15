class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/1.19.0.tar.gz"
  sha256 "37c9dff5eb61be1aa4dc08f6c7fe910385e12244c14c6b163e2ffab373d779d7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_monterey: "8e3b9a6286afa8f99a943808d73b4b168124a7bfd97b9d3d3b6288d24ea013cd"
    sha256 cellar: :any, arm64_big_sur:  "f6fb5f18b6567e290ff6e35ad4aaa178839566856003bf2218a1e1c96f6ac3db"
    sha256 cellar: :any, monterey:       "7c50042db8c573c9d014a95141110a866af161381fcae7efd69e22a9c469e714"
    sha256 cellar: :any, big_sur:        "d14e704c0eb78e5251a059688da572e52a3a8673e655ae7da1ca48ddb704bb59"
    sha256 cellar: :any, catalina:       "e6cfce5f2fe46470b24de30b62a463ad94e020cafa4497cee5ea2a9c85e37bed"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
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
