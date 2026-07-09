class LiquidDsp < Formula
  desc "Digital signal processing library for software-defined radios"
  homepage "https://liquidsdr.org/"
  url "https://github.com/jgaeddert/liquid-dsp/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "abef8b2ddfd58c0a84ecda4f62158c4824b916144af4a2b07776e1a144d8cda4"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "13bd8212fa1f9842b35be703f1248db51e90d4bf70e468c73b6244bd3e502201"
    sha256 cellar: :any, arm64_sequoia: "fc20729e4ac1c4f0f773e74e4050cd8ecee3cf28a99db9875df569693b9ae3d4"
    sha256 cellar: :any, arm64_sonoma:  "bcb5a50a25401bd8b2c27fa713c3aaeab945dfdba4d3eceef9203fb8a4bef668"
    sha256 cellar: :any, sonoma:        "6dff966c147c7beda0c0a4fda7ba755e332bbd42470eb54a856dd501cb3c268a"
    sha256 cellar: :any, arm64_linux:   "73c77bd93263cc8f3a57a225fb3a771fb174975eaf21c3149dbe21d4f515483a"
    sha256 cellar: :any, x86_64_linux:  "853c405307d305281dede43b1dd652610c44edef57cd0905ecbeade835d89f2f"
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
    (testpath/"test.c").write <<~C
      #include <liquid/liquid.h>
      int main() {
        if (!liquid_is_prime(3))
          return 1;
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lliquid"
    system "./test"
  end
end
