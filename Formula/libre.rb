class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "999f02b4299f9f4bbf637cf610099b656225fef0ce08ce56728978214d448343"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dfc4ff002cb4e72448abcb352c1ec66477325c269fbf41b5c9295057067fc17c"
    sha256 cellar: :any,                 arm64_big_sur:  "36259fdf5d3f1c36ff78c06dab6166e8b52afa55db2fd78ad291c1cdb5e8a0f6"
    sha256 cellar: :any,                 monterey:       "4105a841c055bc06d8840c894d7436e04309bcaacd89b9a12da70542a3b26dad"
    sha256 cellar: :any,                 big_sur:        "d679bfe2752efc0ab3724a6e57e2a7cc73673876822cc4cbba5610811fe32533"
    sha256 cellar: :any,                 catalina:       "6e2365de05cf3e4036ec3a14646f3ca161045d3c85821989ab253c024aa811fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "666e655dac68499f9552859550c5998d5039c5d944c4f30dfa5c46ec5bda8309"
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
