class Libscrypt < Formula
  desc "Library for scrypt"
  homepage "https://lolware.net/libscrypt.html"
  url "https://github.com/technion/libscrypt/archive/v1.21.tar.gz"
  sha256 "68e377e79745c10d489b759b970e52d819dbb80dd8ca61f8c975185df3f457d3"

  bottle do
    cellar :any
    sha256 "81c603f27fbda0bde330506d2745f62d3ba16d3290addc5f1eeecbcd110aa801" => :mojave
    sha256 "46cf17f2a05e5e418822a306899de14be3fbdfe71fc017f6eb1169fc3ad1de3a" => :high_sierra
    sha256 "3adc43863f9b966dcecd89f507a4706891f94129dd88ba810ed0269278e931cf" => :sierra
    sha256 "bc2c8318384a72f82802937f7e6dd8017ec44fb6fc94583e5f0c38056e1a660c" => :el_capitan
    sha256 "0e870b01dbbfc49432cc8ea81c90ee6d8732b6d8adc4665368844536d5c6e092" => :yosemite
    sha256 "fe3bc1ca8b19e7c86e103f1345cb9294da01cc15b950302ad5486ef49b2b212d" => :mavericks
  end

  def install
    system "make", "install-osx", "PREFIX=#{prefix}", "LDFLAGS=", "CFLAGS_EXTRA="
    system "make", "check", "LDFLAGS=", "CFLAGS_EXTRA="
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libscrypt.h>
      int main(void) {
        char buf[SCRYPT_MCF_LEN];
        libscrypt_hash(buf, "Hello, Homebrew!", SCRYPT_N, SCRYPT_r, SCRYPT_p);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lscrypt", "-o", "test"
    system "./test"
  end
end
