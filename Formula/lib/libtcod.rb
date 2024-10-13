class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/refs/tags/1.24.0.tar.gz"
  sha256 "13e7ed49f91b897ac637e29295df8eeac24e284fbd9129bb09fd05dba0dcc1fb"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "b2c555de7f9465b453c278c706c9da6a43d7d903e8fda2b013a4c03ff209b938"
    sha256 cellar: :any,                 arm64_sonoma:   "d8385601d9030f40b547ef423f77d33ae522de513e64057a99efbe8c7c48a54b"
    sha256 cellar: :any,                 arm64_ventura:  "f7d1c2301eff1200bb7172cd81dcfd7d564b529a4381f0cf1146c8a541523dad"
    sha256 cellar: :any,                 arm64_monterey: "2b092c9be43872f96b312cfa9065db010719bbf263f78ab99d21bc0c585d8c1e"
    sha256 cellar: :any,                 sonoma:         "d51c4c628b8c80ee955e53cd1dde6ff964c9cfa0fb55f801ac80358d0f639d7b"
    sha256 cellar: :any,                 ventura:        "2a423b3fcac0d162f054ee6af550fcb2932c1d2af63e25e6ed0fec8b1e2b57e4"
    sha256 cellar: :any,                 monterey:       "bcf7a4ac12484cd92da1d898e23c82a83b64d3f39d59d1b7114639cfd91e7146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12e3ee471cffb22ddb86f69bd08aa5f7d39b2acd29709788af1b38a727486780"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on macos: :catalina
  depends_on "sdl2"

  uses_from_macos "python" => :build

  conflicts_with "libzip", because: "libtcod and libzip install a `zip.h` header"

  fails_with gcc: "5"

  def install
    cd "buildsys/autotools" do
      system "autoreconf", "--force", "--install", "--verbose"
      system "./configure", *std_configure_args, "--disable-silent-rules"
      system "make"
      system "make", "install"
    end
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
