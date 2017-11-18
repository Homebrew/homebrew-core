class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.5.6.tar.gz"
  sha256 "a3119826ad162f898ada734d093f565824a018df395b4517549915b00e2bdf69"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e0b8b1dec451dc20dd3f996623198a97071677f4263d4296cb58ebcfdb434783" => :high_sierra
    sha256 "a6ab339d81c065d2792529a0f85a4f8e111b46f82b4a8885fe6cacbea62961f8" => :sierra
    sha256 "f1316e1a83572201a3d05e87f104e9354898e80377f823dc4d410384b5b85554" => :el_capitan
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
