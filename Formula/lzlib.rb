class Lzlib < Formula
  desc "Data compression library"
  homepage "https://www.nongnu.org/lzip/lzlib.html"
  url "https://download.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.12.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.12.tar.gz"
  sha256 "8e5d84242eb52cf1dcc98e58bd9ba8ef1aefa501431abdd0273a22bf4ce337b1"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/lzlib/"
    regex(/href=.*?lzlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ebdc6759b366c12f7884ab27af11752c4d0348b91c3dfdd23f29d3e470dc94fa" => :big_sur
    sha256 "06e131d4c75dc18d8aa6571d4b80ff302c9e0b4c5487d661c9d9d0cd34d93100" => :arm64_big_sur
    sha256 "bd80163e5b149eff8a652ee79b8551af09bba6410d9549c481d680ffb6c5dcb9" => :catalina
    sha256 "d351d2530ffa16a75df2afaf35cad291acca3a8a9374ab0b7b3edfcf1bd4f64d" => :mojave
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CC=#{ENV.cc}",
                          "CFLAGS=#{ENV.cflags}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdint.h>
      #include "lzlib.h"
      int main (void) {
        printf ("%s", LZ_version());
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-llz",
                   "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
