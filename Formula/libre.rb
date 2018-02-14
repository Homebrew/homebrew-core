class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.5.7.tar.gz"
  sha256 "5dcc15610c28ff1df147d28266b29b934adcff43bfc3fdac58767fd789101039"

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
