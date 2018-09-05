class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.5.8.tar.gz"
  sha256 "190fd652da167d8d6351b7a26fa0aef2ddab75fe5e8d5de77edf023988440e70"

  bottle do
    cellar :any
    sha256 "538415bf11082804ed7ab100bf72fa9618ba22e4d51b54dc21314d0ea8d63620" => :high_sierra
    sha256 "a46b8e91cdf25d78db8c0857d89f8123abeb1ecdccf296c4d169326daf72ac04" => :sierra
    sha256 "8fa0389f4c16bc17ae9cfa9f1cba79facbaca9b96f3a02476d4ba2e3541ce568" => :el_capitan
  end

  depends_on "openssl"

  def install
    system "make", "install", "PREFIX=#{prefix}"
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
