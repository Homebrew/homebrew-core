class Lzlib < Formula
  desc "Data compression library"
  homepage "https://www.nongnu.org/lzip/lzlib.html"
  url "https://download.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.9.tar.gz"
  sha256 "2472f8d93830d0952b0c75f67e372d38c8f7c174dde2252369d5b20c87d3ba8e"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a04bccace677f7d391564ce58624d3e2f3b5bc67964be861f952208037d0bec" => :high_sierra
    sha256 "730b7d59b3c8c3f8ca12053b2be57c36effa89f036a0a5c78395455fc3619477" => :sierra
    sha256 "116cf311291d7aaf0c13c5ac9e456a40261d036f75d21c6026e0b1c623bca2f4" => :el_capitan
    sha256 "f7be3aeb9e6142bbf3b35ff6212c81615a2ac02f0a65ad77216bcd15051bf147" => :yosemite
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
