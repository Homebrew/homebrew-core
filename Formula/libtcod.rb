class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/1.23.0.tar.gz"
  sha256 "4b13840769c7369d1c75728b555e26933f513da29c493f73017f0deb3da27e0d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8244bbb31f18bb7737372c9087bbe749232d41a147e5c84fe55cc236c5fc11bd"
    sha256 cellar: :any,                 arm64_monterey: "4065cddda8f1448f7df9984ea73e8813102bdfc68f5bbdc5386256b7847ff777"
    sha256 cellar: :any,                 arm64_big_sur:  "ab0a438306f817bd11535c4953acdd857f99cdb6fcb8060c207380eb3aba93ef"
    sha256 cellar: :any,                 monterey:       "d43ebb17eafbd7c5b39167dd6b3008d96e7ee6f4738e8c93102ee40553a64782"
    sha256 cellar: :any,                 big_sur:        "90e0aaf9dd7fbbd670889113d78e885a34e5e04ef389c66580e488a3f4d6768b"
    sha256 cellar: :any,                 catalina:       "6a476ccabdeda32c5405d77e8f98837efa4beecfa34344ce02a259c93295f06a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b83468c99c5c51043c413d8567843e6246a7e1db780ad0ca4c6185c44dd76cb"
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
