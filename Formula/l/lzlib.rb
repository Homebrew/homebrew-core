class Lzlib < Formula
  desc "Data compression library"
  homepage "https://www.nongnu.org/lzip/lzlib.html"
  url "https://download.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.15.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.15.tar.gz"
  sha256 "4afab907a46d5a7d14e927a1080c3f4d7e3ca5a0f9aea81747d8fed0292377ff"
  license "BSD-2-Clause"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/lzlib/"
    regex(/href=.*?lzlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87bcb4061bb953be6a3a89673b3671923af705d5cb38856b5859fb71f6dc1128"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7d49c0b61af344aec1da7f037ec59ce9c36f79a9b7606794e15697c7b04f0ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f957b6e8a1170b0fe93bfca8004cb9467d8496688f56999c6088aecd90ad59e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e294db70263a4a544a032cb1574a8493d0a0e1830ccaccd5181b8b793fd87ba"
    sha256 cellar: :any_skip_relocation, ventura:       "37d32f4cd2440fa0f6a73492c7e585f037fc6cb189f57dfeb6023e9cd3d7403e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a91ac1ac39e250d4245285e4db6581ab1c801b329537933661e418eda81ab976"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e55a6c95515ea3ffc18c2486dfbb3819cdfddc6fc7b0a86b11c0c62f81f2cc0"
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
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdint.h>
      #include "lzlib.h"
      int main (void) {
        printf ("%s", LZ_version());
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-llz",
                   "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
