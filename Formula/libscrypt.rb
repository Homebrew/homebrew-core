class Libscrypt < Formula
  desc "Library for scrypt"
  homepage "https://github.com/technion/libscrypt"
  url "https://github.com/technion/libscrypt/archive/v1.22.tar.gz"
  sha256 "a2d30ea16e6d288772791de68be56153965fe4fd4bcd787777618b8048708936"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "27b5cd1ef28e190b9f73c5c617ee652b331eab24cb25bd3129335ad1c0299f76"
    sha256 cellar: :any,                 arm64_monterey: "df9e62c90fb8530ad765f2128a892ba91904901167bb5dcb7f0e1a199b43f59f"
    sha256 cellar: :any,                 arm64_big_sur:  "6b39d428937056b1a25080c87d9af446ae1397f824d362ca6a791e683a997ed2"
    sha256 cellar: :any,                 ventura:        "ce5a3c6a6e0f0e100eb6b9d515389a371ac2bdc3f18b4aeb7f0909ce8b3b4b99"
    sha256 cellar: :any,                 monterey:       "d8e0b6fe9b5e2f14fc281fa859fb3339eb98610863cb0b39652f5cb6522205ad"
    sha256 cellar: :any,                 big_sur:        "836c0ae075b9e3b580eea4d3c1b554f861166f74657303103bb0415c34650fb8"
    sha256 cellar: :any,                 catalina:       "d53d94bee86fdb65f96abdb62f07f5f2867773fd0719562a21ad320465ebd686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62ae9fdeea1cbe282839585250e2adacea715d313975bf6eb863a579aa669a21"
  end

  def install
    if OS.mac?
      system "make", "install-osx", "PREFIX=#{prefix}", "LDFLAGS=", "LDFLAGS_EXTRA=", "CFLAGS_EXTRA="
      system "make", "check", "LDFLAGS=", "LDFLAGS_EXTRA=", "CFLAGS_EXTRA="
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
