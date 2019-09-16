class Libvterm < Formula
  desc "C99 library which implements a VT220 or xterm terminal emulator"
  homepage "http://www.leonerd.org.uk/code/libvterm/"
  url "http://www.leonerd.org.uk/code/libvterm/libvterm-0.1.tar.gz"
  sha256 "e419c58ea71e392c9084cb872ae75bc2d07177d859b8efe9702243de36949ddd"
  version_scheme 1

  bottle do
    cellar :any
    sha256 "eca96b4e33236df8805d8fa53641e2a91e01ad49370bf492a9b2db327115f6bd" => :mojave
    sha256 "90ce34a766b2a67d2d7a47929e3bbcbac8645a7bee74ab33119e6db49b1ef903" => :high_sierra
    sha256 "6bd97ffe3d76adaa2f8b968af5201e8325b97b40d70ee4340c9606b6c8ff4e9e" => :sierra
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
