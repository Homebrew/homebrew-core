class Libvterm < Formula
  desc "C99 library which implements a VT220 or xterm terminal emulator"
  homepage "http://www.leonerd.org.uk/code/libvterm/"
  url "http://www.leonerd.org.uk/code/libvterm/libvterm-0.1.4.tar.gz"
  sha256 "bc70349e95559c667672fc8c55b9527d9db9ada0fb80a3beda533418d782d3dd"
  license "MIT"
  version_scheme 1

  livecheck do
    url :homepage
    regex(/href=.*?libvterm[._-]v?(\d+(?:\.\d+)+)\./i)
  end

  bottle do
    cellar :any
    sha256 "73b78f138e6575528d7f197f63897be167c712698744c5e11852a9e976e8d1d5" => :big_sur
    sha256 "969c3ccfed1e025aeb191eff20c8942ff54358553c3501bfb270973ec5a00bb0" => :arm64_big_sur
    sha256 "b62a78631bca9a723eb25dd924853ced974718df0847820c7c38f7f0d7fdc43c" => :catalina
    sha256 "56946cfa43a7bcf3b47086d61541b2a0541d636a362c788401f51b29cf6fa35f" => :mojave
    sha256 "518299bd4bde4aeb3063df624e4c474280ac15a8e65f612059c7d03717b143ac" => :high_sierra
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
