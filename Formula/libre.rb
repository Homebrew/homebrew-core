class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "6aa9622bc0fee6881770e0b374161df44edb395b5d295fc8c56e7b6fa18a8ea2"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c9d13f5cfd19e445ee6940ada9a205928e7fa4e251e21ca77a194c2ab0da7dc7"
    sha256 cellar: :any,                 arm64_big_sur:  "f96d42e8a4cc662078287e4c1ef4fb6a5569d87a5f7ca7eeb1fd1595ab24f3c7"
    sha256 cellar: :any,                 monterey:       "839bcfd1f518481284c120686b90150806df6a0b277846f7e5c213c830188064"
    sha256 cellar: :any,                 big_sur:        "465058f24f0ea2150a458acedff45bde42b2e75818d7b952fdd3bb99d037ff58"
    sha256 cellar: :any,                 catalina:       "934f00f6db6893826e786e1ed4d84fcb275862f266e4495e276ef651811e674b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dece71198fb227417401bbb6ccf50c841ae7cea2c7978e92b8439e208939562d"
  end

  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    sysroot = "SYSROOT=#{MacOS.sdk_path}/usr" if OS.mac?
    system "make", *sysroot, "install", "PREFIX=#{prefix}", "RELEASE=1", "V=1"
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
