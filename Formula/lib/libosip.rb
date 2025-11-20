class Libosip < Formula
  desc "Implementation of the eXosip2 stack"
  homepage "https://www.gnu.org/software/osip/"
  url "https://ftpmirror.gnu.org/gnu/osip/libosip2-5.3.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/osip/libosip2-5.3.1.tar.gz"
  sha256 "fe82fe841608266ac15a5c1118216da00c554d5006e2875a8ac3752b1e6adc79"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/href=.*?libosip2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "8c2b8a49121fa1e1975470aea9d13f5803bb8a9f68b23497b8c5d4fd25b8b90f"
    sha256 cellar: :any,                 arm64_sequoia:  "751eaf3b56ce1d3f5ad7e076909391f1cef386f430cd96719ff8a97bcc76bd03"
    sha256 cellar: :any,                 arm64_sonoma:   "ae8d66cfe67d8dc40a0299db6cfb154cbc28c8c6a7af0229d4577e70e7d54ca5"
    sha256 cellar: :any,                 arm64_ventura:  "34fbd0c4413173a442968eec773e3a9b5f60a9a08b48af2f3e2d9d4ee21e6dab"
    sha256 cellar: :any,                 arm64_monterey: "2bcc9aaabdfd1b5afe6a05a3cd694f91b3dae3a23189f450cbe028a9416a28dc"
    sha256 cellar: :any,                 arm64_big_sur:  "97a6519a92630d395d060289ebd2959d91302d84efa15d72aa9f37f9293ce7fa"
    sha256 cellar: :any,                 sonoma:         "d867ac12d12785e834dea9f2dd560ed2e660227dfadcd080359b2c14637cc2ab"
    sha256 cellar: :any,                 ventura:        "c7fca9a24a759d0716ef0293fdff8361cdadab5963e7d3f36fbc4405b49e27a1"
    sha256 cellar: :any,                 monterey:       "208378ce5567b92f8d1fcf79a9e07bea8313c90da24f7e14b4d5a5c9f9a3c9ab"
    sha256 cellar: :any,                 big_sur:        "947aa52f8073bc404457457f25c121066c6bb6af9ebeb42b3c50e4168b3cbac6"
    sha256 cellar: :any,                 catalina:       "eb877b96fdc42eca7b4df03ae438982a3fc1e0abc51373bd6c559ba39d2077e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0aa814193eae6de3270a53f3bac4bcbaa76061111d5124843d2a1c43af0680f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca0d378c03efdfb96e5e0610357fab268feb1a92de587ac55fa453e4f20b75e4"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <sys/time.h>
      #include <osip2/osip.h>

      int main() {
          osip_t *osip;
          int i = osip_init(&osip);
          if (i != 0)
            return -1;
          return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-losip2", "-o", "test"
    system "./test"
  end
end
