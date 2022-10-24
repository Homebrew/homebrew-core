class Libosip < Formula
  desc "Implementation of the eXosip2 stack"
  homepage "https://www.gnu.org/software/osip/"
  url "https://ftp.gnu.org/gnu/osip/libosip2-5.3.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/osip/libosip2-5.3.1.tar.gz"
  sha256 "fe82fe841608266ac15a5c1118216da00c554d5006e2875a8ac3752b1e6adc79"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/href=.*?libosip2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4043472a783cff927c822e5c0b20d6ca016f14cc056578c65f8f9f0a2b2bbb9e"
    sha256 cellar: :any,                 arm64_monterey: "10b2ccc4ecbd787145593f7471be07f8d7d337b88f0910c65a90fde3a74c7153"
    sha256 cellar: :any,                 arm64_big_sur:  "83a8054802766537ac0bf9a7a26a4e058196659d22b3e73fdc4ca1e1465eebd4"
    sha256 cellar: :any,                 monterey:       "5257a4db4c419617cb61facd541b0dfd065cf65b04522ba129508153f1cba76f"
    sha256 cellar: :any,                 big_sur:        "c1c218af9476972bd79a997ed6d17b15585a819da6a8f48e465a3a2e0dd46bcb"
    sha256 cellar: :any,                 catalina:       "1ce96e56712d36f561bceb138de9c2213340f20a22e20ef0d18fcb5d7539ed72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5250bfa31928e5b25d34dd4a10d2d70d9a8f8e18aec0af8846c3f6c974a13171"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <sys/time.h>
      #include <osip2/osip.h>

      int main() {
          osip_t *osip;
          int i = osip_init(&osip);
          if (i != 0)
            return -1;
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-losip2", "-o", "test"
    system "./test"
  end
end
