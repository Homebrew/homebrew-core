class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.5.9.tar.gz"
  sha256 "882ba05cae77e07099add1d24195863d08fcddfef62d1586d8d07f1721b59612"

  bottle do
    cellar :any
    sha256 "538415bf11082804ed7ab100bf72fa9618ba22e4d51b54dc21314d0ea8d63620" => :high_sierra
    sha256 "a46b8e91cdf25d78db8c0857d89f8123abeb1ecdccf296c4d169326daf72ac04" => :sierra
    sha256 "8fa0389f4c16bc17ae9cfa9f1cba79facbaca9b96f3a02476d4ba2e3541ce568" => :el_capitan
  end

  depends_on "openssl"

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
