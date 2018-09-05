class Libvterm < Formula
  desc "C99 library which implements a VT220 or xterm terminal emulator"
  homepage "http://www.leonerd.org.uk/code/libvterm/"
  url "http://www.leonerd.org.uk/code/libvterm/libvterm-0+bzr681.tar.gz"
  sha256 "abea46d1b0b831dec2af5d582319635cece63d260f8298d9ccce7c1c2e62a6e8"

  bottle do
    cellar :any
    sha256 "c59aeeacfeacbd9178f487c23eee72be248fa0c310812d8f131f2d68cc209993" => :mojave
    sha256 "d9890959bfaffea27748b69bdcd8f84b1ccc104829db37480dcfdd86701fa315" => :high_sierra
    sha256 "1b0e1cd45ec1aa67280fa555c47139d2d0b36d7c28313148bd7d23d85a31178c" => :sierra
    sha256 "fdab6481377220ea48474d7af256df3b82ee202d28ba010d644aa5ff200c2fbd" => :el_capitan
    sha256 "e74dceb0e58c42be4c8e1ab96867ad71931b9412b7c692cfc40dc5bc924d0daa" => :yosemite
    sha256 "a3b42686b7e365b71c766cfb44bb564e5d0e157ac85cf9b9ffba6b6d570f3ef8" => :mavericks
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
