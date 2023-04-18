class LiquidDsp < Formula
  desc "Digital signal processing library for software-defined radios"
  homepage "https://liquidsdr.org/"
  url "https://github.com/jgaeddert/liquid-dsp/archive/v1.5.0.tar.gz"
  sha256 "93003edb6e74090b41009b1fae6f273a3e711dc4c8c56a0cca3e89167b765953"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "824e640ecb98dba3eacd1e310d2aa91cd6a9fdbc7d19d54c58ec3d12e70c76e7"
    sha256 cellar: :any,                 arm64_monterey: "c2824a45af2851ce70f2bd1abede9ec974a5c60d7ccd10265a2ec874fd5edbb7"
    sha256 cellar: :any,                 arm64_big_sur:  "4a8dd743e29c5704a0ef697f1c88b67d9373b246c5b18447b2be2264331f45d1"
    sha256 cellar: :any,                 ventura:        "2b57763c8e8e322e08ef7e5cbd3cf91fe06053a7b79c100c1f5dba50bf10c43a"
    sha256 cellar: :any,                 monterey:       "f588d707c472176a2299a83ae4a5be4c6650cffad836fac944b6b3e5af37ebf2"
    sha256 cellar: :any,                 big_sur:        "e9c254a3a7769a511ee63e1424c4236e2e47c129cb013e9669ce66045a7a6e82"
    sha256 cellar: :any,                 catalina:       "9c4aaa2b4e3750fef350ec92bd05d1e18eba2b3709fd4b3b8c78df7279cc1da5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c24b3940c77bb064ce4769a3bc18cf2b78b79b9ce4c71f170c0f194460047f75"
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
