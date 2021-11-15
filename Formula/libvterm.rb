class Libvterm < Formula
  desc "C99 library which implements a VT220 or xterm terminal emulator"
  homepage "http://www.leonerd.org.uk/code/libvterm/"
  url "http://www.leonerd.org.uk/code/libvterm/libvterm-0.2.tar.gz"
  sha256 "4c5150655438cfb8c57e7bd133041140857eb04defd0e544521c0e469258e105"
  license "MIT"
  version_scheme 1

  livecheck do
    url :homepage
    regex(/href=.*?libvterm[._-]v?(\d+(?:\.\d+)+)\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5cd306979b892e89d43e58c6259c9631101d7dc685addc6fe306d42e5a746ac4"
    sha256 cellar: :any,                 arm64_big_sur:  "45364ba93182739f8d2b5fd17c98f23ea04c5f3d2bea8bfbc4505e3d7fe8405c"
    sha256 cellar: :any,                 monterey:       "5eaf3c64effc28db52d1da5e9d974646e8fd57926a96435cb75200591c321a97"
    sha256 cellar: :any,                 big_sur:        "feca616448c260cf992bc1a58eb537028d08cf0af008003b09c1602f81eabe75"
    sha256 cellar: :any,                 catalina:       "397b586af09ebea105af914adeb0ca6f943ca2b3f1948555e3336b21c6e39833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaa7a320354097e4ca5c0c3f6ef1310d62cdce4d941e3b0a1ffae19eec262758"
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
