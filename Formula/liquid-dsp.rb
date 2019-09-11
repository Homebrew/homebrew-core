class LiquidDsp < Formula
  desc "Digital signal processing library for software-defined radios"
  homepage "https://liquidsdr.org/"
  url "https://github.com/jgaeddert/liquid-dsp/archive/v1.3.2.tar.gz"
  sha256 "85093624ef9cb90ead64c836d2f42690197edace1a86257d6524c4e4dc870483"

  bottle do
    cellar :any
    sha256 "12702bbff57912c18a4f637df59da56054f8afcc11f96467341af3bd26ec0992" => :mojave
    sha256 "f0a6f6caba39b3e06a972aa89293161fa6d4d3759751709f40f2cc8d7ea3c913" => :high_sierra
    sha256 "10bca6603365aeefad410287fbf1657b6b2401544e2cc16f1f2ef6f9ffbe8bc9" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "fftw"

  def install
    system "./bootstrap.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <liquid/liquid.h>
      int main() {
        if (!liquid_is_prime(3))
          return 1;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lliquid"
    system "./test"
  end
end
