class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.5.8.tar.gz"
  sha256 "190fd652da167d8d6351b7a26fa0aef2ddab75fe5e8d5de77edf023988440e70"

  bottle do
    cellar :any
    sha256 "1a6685679f1e26b0a77013714d8e47234e8e72b292980203550bf0924890da4b" => :high_sierra
    sha256 "41e126cd681c2aaf8b6cab6431487d5458f549f697dc1e7f1fea2cdb71ca3b07" => :sierra
    sha256 "6ff38e8060c4f59fce104db8dc13e7620ae024545e84783694682f09b81eae7a" => :el_capitan
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
