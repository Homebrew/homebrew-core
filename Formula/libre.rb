class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "ecd8c84371ff4fd16dcc9c98c94227e3964da9031908067c0564d6354125c814"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ab3b5a3871a7a64a1a22f98ebb9bb15c688d905c89f281e1dfeaa804004c9ec6"
    sha256 cellar: :any,                 arm64_big_sur:  "4b16b5fae741b6425a10ba95b946531073bd1f0aa4ca215402d0ec94df42aeba"
    sha256 cellar: :any,                 monterey:       "a875b54c06c57a45ac577165f1ec3e3620237175523b0a7f0b9785f265b67794"
    sha256 cellar: :any,                 big_sur:        "bd3b5ce3379ae15ac0ce2f4d9537b71a36fc05047ecdb2dcad38138350d0c41f"
    sha256 cellar: :any,                 catalina:       "e49167097672bc5940b6409a232508b04047c6c51e2d5b610df91dca0fce8fb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76b8e0a5fa6ae77e9762b3ec88755e0e1ad5304e2afc48688cb824cf45c7395a"
  end

  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    sysroot = "SYSROOT=#{MacOS.sdk_path}/usr" if OS.mac?
    system "make", *sysroot, "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lre"
  end
end
