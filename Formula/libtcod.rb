class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/1.22.2.tar.gz"
  sha256 "8a19a44435bbf9ebecceb1b080cae6fb2cf4d3373fabf42536662c9f8b77acdf"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f975f175cace10522bf03f9525fce0dc470f5440adb85390192e3a5c44860294"
    sha256 cellar: :any,                 arm64_big_sur:  "4bdd43d12fc779650ebc1d13d18cc10671ffb580bd082070b979ce96847733f5"
    sha256 cellar: :any,                 monterey:       "8fb58fee4b28729b34dc6f36b09140885184bdfeabe7974647d2023b6fa6f6f4"
    sha256 cellar: :any,                 big_sur:        "97cfc0147fa2235768a542e265eb03d587a4d705588b215bc31d33c163163455"
    sha256 cellar: :any,                 catalina:       "5cd8a6b85f802ba2f75e186ab0177f1a2d61f0db19d4391a7088e2b718137942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d361445036eb2dc299f250dc51b91887722618320eaf5024af2889aa5598a2e9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on macos: :catalina
  depends_on "sdl2"

  on_linux do
    depends_on "gcc"
  end

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
