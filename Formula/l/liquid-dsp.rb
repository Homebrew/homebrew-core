class LiquidDsp < Formula
  desc "Digital signal processing library for software-defined radios"
  homepage "https://liquidsdr.org/"
  url "https://github.com/jgaeddert/liquid-dsp/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "18fa83b73db8bb6fe6ea0376e4b5aecf8645970f4604d10d9dadbf609f3f95e2"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "08f26b099934aba3db8a1a0c7b312f1fbc05a3790e7469d1e1433edcf972196c"
    sha256 cellar: :any, arm64_tahoe:       "3edba8c938fce60d57b7cfef877a5cf2e82c5c547b4e748b9731c8048e6b9492"
    sha256 cellar: :any, arm64_sequoia:     "1625b8ac210ee3edb1bf5763baf33ac8706c43eead41be7e3f3d27ab1a0d71b0"
    sha256 cellar: :any, arm64_linux:       "270dc966585dccfe228ee8d83e542eb5973f1a0f2880f12268b614e21eef3ae7"
    sha256 cellar: :any, x86_64_linux:      "a2fa13745f522f7060306acd7aaac916e2220b53c29c290481b4b761cad67f56"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "fftw"

  deny_network_access!

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
