class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.6.0.tar.gz"
  sha256 "0e97bcb5cc8f84d6920aa78de24c7d4bf271c5ddefbb650848e0db50afe98131"
  revision 1

  bottle do
    cellar :any
    sha256 "137fa333c3dc08e8e6f156c81ec6734eea2049f11a48ef24dfb9cf104813240a" => :mojave
    sha256 "f04fcd625ccec1dabdd048a7cfe9148ca7ede4d52aad756ebd91e65ff637834b" => :high_sierra
    sha256 "d44460ba46fbe86f7aa1dc66c3a81fb4d047c0ab90184820112ecbfbf5c9955b" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    system "make", "SYSROOT=#{MacOS.sdk_path}/usr", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lre"
  end
end
