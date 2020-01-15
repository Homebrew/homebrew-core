class Libvterm < Formula
  desc "C99 library which implements a VT220 or xterm terminal emulator"
  homepage "http://www.leonerd.org.uk/code/libvterm/"
  url "http://www.leonerd.org.uk/code/libvterm/libvterm-0.1.3.tar.gz"
  sha256 "e41724466a4658e0f095e8fc5aeae26026c0726dce98ee71d6920d06f7d78e2b"
  version_scheme 1

  bottle do
    cellar :any
    sha256 "74c971c0a3157f7b34c69360c7b76611dcbb949e50ba255603a70f3d643e7cca" => :catalina
    sha256 "da5f5c504963d145c7a5e2ac9fd0fc0d9008251f98b11fbc6f818da59057c128" => :mojave
    sha256 "3362cf826401b4c9d4012de2777eecd90b3b168b723f51371adb5eb18e22fbc9" => :high_sierra
  end

  depends_on "libtool" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <vterm.h>

      int main() {
        vterm_free(vterm_new(1, 1));
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lvterm", "-o", "test"
    system "./test"
  end
end
