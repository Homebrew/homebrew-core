class Libscrypt < Formula
  desc "Library for scrypt"
  homepage "https://github.com/technion/libscrypt"
  url "https://github.com/technion/libscrypt/archive/v1.21.tar.gz"
  sha256 "68e377e79745c10d489b759b970e52d819dbb80dd8ca61f8c975185df3f457d3"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e9a021a77ed0361c955d6c87520e37cb5fcab46668e14ccf0b576b32a45dc553"
    sha256 cellar: :any,                 arm64_big_sur:  "1073aa38a72ed089bf6e6a6a4fbddb6e6123b394e7562d1e1ad5b26cc67906dd"
    sha256 cellar: :any,                 monterey:       "7ead68bfb6c9f5e0d1a6cd6b76e6cfd79d2729031cd5d7b8493cb46a998b481b"
    sha256 cellar: :any,                 big_sur:        "c2c67b09b54467e47709dbe7340c1916e0802a5423b4f2224156ce7bb977e389"
    sha256 cellar: :any,                 catalina:       "66ea017c5361346903add978ce85b09a2a6f2e8eabdf9fb2cfb58809da1d29cd"
    sha256 cellar: :any,                 mojave:         "81c603f27fbda0bde330506d2745f62d3ba16d3290addc5f1eeecbcd110aa801"
    sha256 cellar: :any,                 high_sierra:    "46cf17f2a05e5e418822a306899de14be3fbdfe71fc017f6eb1169fc3ad1de3a"
    sha256 cellar: :any,                 sierra:         "3adc43863f9b966dcecd89f507a4706891f94129dd88ba810ed0269278e931cf"
    sha256 cellar: :any,                 el_capitan:     "bc2c8318384a72f82802937f7e6dd8017ec44fb6fc94583e5f0c38056e1a660c"
    sha256 cellar: :any,                 yosemite:       "0e870b01dbbfc49432cc8ea81c90ee6d8732b6d8adc4665368844536d5c6e092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "017ce8d5d59d3912f2f73cd35d33b6bffae8d8dd10a91bc7b53644a5d959645e"
  end

  def install
    if OS.mac?
      system "make", "install-osx", "PREFIX=#{prefix}", "LDFLAGS=", "CFLAGS_EXTRA="
      system "make", "check", "LDFLAGS=", "CFLAGS_EXTRA="
    else
      system "make"
      system "make", "check"
      lib.install "libscrypt.a", "libscrypt.so", "libscrypt.so.0"
      include.install "libscrypt.h"
      prefix.install "libscrypt.version"
    end
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
