class Libvterm < Formula
  desc "C99 library which implements a VT220 or xterm terminal emulator."
  homepage "http://www.leonerd.org.uk/code/libvterm/"
  url "http://www.leonerd.org.uk/code/libvterm/libvterm-0+bzr681.tar.gz"
  sha256 "abea46d1b0b831dec2af5d582319635cece63d260f8298d9ccce7c1c2e62a6e8"

  depends_on "libtool" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <vterm.h>

      int main() {
        vterm_free(vterm_new(1, 1));
      }
    EOS

    system ENV.cc, "test.c", "-lvterm", "-o", "test"
    system "./test"
  end
end
