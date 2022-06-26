class LiquidDsp < Formula
  desc "Digital signal processing library for software-defined radios"
  homepage "https://liquidsdr.org/"
  url "https://github.com/jgaeddert/liquid-dsp/archive/v1.4.0.tar.gz"
  sha256 "66f38d509aa8f6207d2035bae5ee081a3d9df0f2cab516bc2118b5b1c6ce3333"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5525a2714e2baa91de8f2a08f1c650446358185b6c560038bf996096d6944b91"
    sha256 cellar: :any,                 arm64_big_sur:  "857eb55de818dc04505bcc75c87d9a90dba7ad4adfe3c1e7a499def9fccb0459"
    sha256 cellar: :any,                 monterey:       "43302c6bab18caf9875454bbb1be50b9d21941d1acd2f1b89d3b62c189434be9"
    sha256 cellar: :any,                 big_sur:        "f922ccf08ab5854dd13926f597cc2941a7da65782979f96ac18fec489ed76e7b"
    sha256 cellar: :any,                 catalina:       "7e4e09278e8c3cc2fd14284cf203563db6c471ba6411457391be897d48f05495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b44afc5d89530c5a20db1f0cd619fffcfd34a13619331068b9277ceb0739bd3c"
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
