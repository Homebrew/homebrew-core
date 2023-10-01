class Libvterm < Formula
  desc "C99 library which implements a VT220 or xterm terminal emulator"
  homepage "http://www.leonerd.org.uk/code/libvterm/"
  url "http://www.leonerd.org.uk/code/libvterm/libvterm-0.3.2.tar.gz"
  sha256 "91eb5088069f4e6edab69e14c4212f6da0192e65695956dc048016a0dab8bcf6"
  license "MIT"
  version_scheme 1

  livecheck do
    url :homepage
    regex(/href=.*?libvterm[._-]v?(\d+(?:\.\d+)+)\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4c11f7028f54d461c59a80b9ade2a41fe9bf876647bbab420e0e5c32cddec725"
    sha256 cellar: :any,                 arm64_ventura:  "1036d2b71dcfb1de60cb8acd9879672db90046413cf719cacebf72eb27eb61eb"
    sha256 cellar: :any,                 arm64_monterey: "d68c3a517df9d1fa88def343438b41b50544128f551bed34d9782e733ec4c4eb"
    sha256 cellar: :any,                 arm64_big_sur:  "226a1fe8102120b080c9c61440de0d23d8f4c276315687aaa2ab1f0c8e96460c"
    sha256 cellar: :any,                 sonoma:         "9d21a41591de1a168b089fe26d30c3f89750e74a850e70f414e06ce80ae90342"
    sha256 cellar: :any,                 ventura:        "94719fc8256bdfc148d7e8652a03d3289d92d5820883cb3adc8eb65289c7f30b"
    sha256 cellar: :any,                 monterey:       "99bb62b30942f55b3cc7cf20dee50b6ce74af44b91db8f897b98083185c79a7f"
    sha256 cellar: :any,                 big_sur:        "ddef5f71dc2d83963c6399f68ac63b2e3acdba5aa3e64a55942f42364e4df0cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50dc8ee89d6788da291f3920c3ea66210e8fae13755a0b1d7c3c13cba9e1a8ec"
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
