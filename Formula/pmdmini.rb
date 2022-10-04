class Pmdmini < Formula
  desc "Plays music in PC-88/98 PMD chiptune format"
  homepage "https://github.com/mistydemeo/pmdmini"
  url "https://github.com/mistydemeo/pmdmini/archive/v2.0.0.tar.gz"
  sha256 "e3288dcf356e83ef4ad48cde44fcb703ca9ce478b9fcac1b44bd9d2d84bf2ba3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "1bdf417d67bfd4312694a9c5e8cdc70d1ed9c749d39a7082ac92fff2210c8fec"
    sha256 cellar: :any, arm64_big_sur:  "7d9638e8edf8d9124f682b6a9d6ebd379d5afe4431ffb09bbf987a86fe3a5529"
    sha256 cellar: :any, monterey:       "ad0c82a61af3d50f6dad3745021d1bd4f82525ffc1eb52139eed94e0b5bbc3c0"
    sha256 cellar: :any, big_sur:        "c23d6cfa04ca47e7d11580620694bedf2cc943b697c49198b80b0aaf489352b1"
    sha256 cellar: :any, catalina:       "422add6136c6829f5ba656e0a052dd2c03f118c665a3fc3bb74a3e4091d8f2e5"
  end

  depends_on "sdl2"

  resource "test_song" do
    url "https://ftp.modland.com/pub/modules/PMD/Shiori%20Ueno/His%20Name%20Is%20Diamond/dd06.m"
    sha256 "36be8cfbb1d3556554447c0f77a02a319a88d8c7a47f9b7a3578d4a21ac85510"
  end

  # Add missing include
  # Upstreamed here: https://github.com/mistydemeo/pmdmini/pull/3
  patch :DATA

  def install
    # Add -fPIC on Linux
    # Upstreamed here: https://github.com/mistydemeo/pmdmini/pull/3
    inreplace "mak/general.mak", "CFLAGS = -O2", "CFLAGS = -fPIC -O2 -fpermissive"
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}", "LD=#{ENV.cxx}"

    # Makefile doesn't build a dylib
    flags = if OS.mac?
      ["-dynamiclib",
       "-install_name", "#{lib}/libpmdmini.dylib",
       "-undefined", "dynamic_lookup"]
    else
      ["-shared"]
    end

    system ENV.cxx, *flags, "-o", shared_library("libpmdmini"), *Dir["obj/*.o"]

    bin.install "pmdplay"
    lib.install "libpmdmini.a", shared_library("libpmdmini")
    (include/"libpmdmini").install Dir["src/*.h"]
    (include/"libpmdmini/pmdwin").install Dir["src/pmdwin/*.h"]
  end

  test do
    resource("test_song").stage testpath
    (testpath/"pmdtest.c").write <<~EOS
      #include <stdio.h>
      #include "libpmdmini/pmdmini.h"

      int main(int argc, char** argv)
      {
          char title[1024];
          pmd_init();
          pmd_play(argv[1], argv[2]);
          pmd_get_title(title);
          printf("%s\\n", title);
      }
    EOS
    system ENV.cc, "pmdtest.c", "-L#{lib}", "-lpmdmini", "-o", "pmdtest"
    result = `#{testpath}/pmdtest #{testpath}/dd06.m #{testpath}`.chomp
    assert_equal "mus #06", result
  end
end

__END__
diff --git a/sdlplay.c b/sdlplay.c
index 14c721e..1338cf9 100644
--- a/sdlplay.c
+++ b/sdlplay.c
@@ -1,3 +1,4 @@
+#include <signal.h>
 #include <stdio.h>
 #include <SDL.h>
