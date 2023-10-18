class Lzlib < Formula
  desc "Data compression library"
  homepage "https://www.nongnu.org/lzip/lzlib.html"
  url "https://download.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.13.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.13.tar.gz"
  sha256 "a1ab58f3148ba4b2674e938438166042137a9275bed747306641acfddc9ffb80"
  license "BSD-2-Clause"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/lzlib/"
    regex(/href=.*?lzlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45bf6b85875f02e1a94c938123da59198b4a137c2ecb8fc48ac9abc85d0bb331"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7680f6b9e88140a4127d37f2205fd3234d0317a1c544c0d95e4d7b11c3befc6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb6304909f4579b58ff3b2587d1f0ef8d97e839d0398790a4bc6a274d51dce76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90f5f6d7704043f05267c00c988a5e72f383bfa3d68628c7a683b6177ea6e542"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8bfa26eddd6dcce95efac6b685926c13855133e8ebdb4002306b5f7b2be82b9"
    sha256 cellar: :any_skip_relocation, ventura:        "1e9c552f96203f479d1a841e8c56bf665fb1bbd3bd273e6038bfef3f9f9e976d"
    sha256 cellar: :any_skip_relocation, monterey:       "65567eae315c3176ca1615459a72f9145226670c34b3b7e190e38501a3c8000c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e87447e82af22377a309c648689820893e0add73356567e83e119a1bed9a28b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84f6f26a7974d145e0b115ac9150547296fb6d812a9c565d63fa72556b4f58c4"
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
