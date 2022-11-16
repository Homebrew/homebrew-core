class Libvterm < Formula
  desc "C99 library which implements a VT220 or xterm terminal emulator"
  homepage "http://www.leonerd.org.uk/code/libvterm/"
  url "http://www.leonerd.org.uk/code/libvterm/libvterm-0.3.tar.gz"
  sha256 "61eb0d6628c52bdf02900dfd4468aa86a1a7125228bab8a67328981887483358"
  license "MIT"
  version_scheme 1

  livecheck do
    url :homepage
    regex(/href=.*?libvterm[._-]v?(\d+(?:\.\d+)+)\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2948569d2a9ef42012e53f5596e6c57d0579ba2fd67289276aee87f838aa18d0"
    sha256 cellar: :any,                 arm64_monterey: "a1f3253ab0132353337dda08fd4cb4813a7feb0985f109439295f779b502637b"
    sha256 cellar: :any,                 arm64_big_sur:  "d3edd5f0a00464f01ef2994845724f30e920c0278d2f3c664d83ced7edf441ef"
    sha256 cellar: :any,                 ventura:        "961518ea7372798bb713451dd3a6a1d2a2b344a749028dbc2c44951dc7a4a635"
    sha256 cellar: :any,                 monterey:       "512bcb9ef343d4179be42ce254d150c2501915d1c32d41b003df82864cc3a245"
    sha256 cellar: :any,                 big_sur:        "999760fd3801afdc3d79e0cf95c3de23233649c191797385c535738b979ae303"
    sha256 cellar: :any,                 catalina:       "8c73c0852230a0302efef48f61a3257322c32b104df3b924b0585b2f402578a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "313e6d0a86af3f5788ebb3d27e2ee7b3a0bed3855e60acdbbc0c6356cf90ba8a"
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
