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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad165df26fa141dc21c58b0fd9adf2427aebc23ef3f7e43b5e64a59582fa371c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06e131d4c75dc18d8aa6571d4b80ff302c9e0b4c5487d661c9d9d0cd34d93100"
    sha256 cellar: :any_skip_relocation, monterey:       "319d882b6cc4a10c3eb64c43467f58bbabceba3130b797f0df46dfd75ee17061"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebdc6759b366c12f7884ab27af11752c4d0348b91c3dfdd23f29d3e470dc94fa"
    sha256 cellar: :any_skip_relocation, catalina:       "bd80163e5b149eff8a652ee79b8551af09bba6410d9549c481d680ffb6c5dcb9"
    sha256 cellar: :any_skip_relocation, mojave:         "d351d2530ffa16a75df2afaf35cad291acca3a8a9374ab0b7b3edfcf1bd4f64d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b006ac595f6da4ef6ed21289317b78d69e3bb615f20906cf7eb9874ce30b0ae1"
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
