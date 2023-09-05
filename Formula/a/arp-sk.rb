class ArpSk < Formula
  desc "ARP traffic generation tool"
  homepage "https://web.archive.org/web/20180223202629/sid.rstack.org/arp-sk/"
  url "https://web.archive.org/web/20180223202629/sid.rstack.org/arp-sk/files/arp-sk-0.0.16.tgz"
  mirror "https://pkg.freebsd.org/ports-distfiles/arp-sk-0.0.16.tgz"
  sha256 "6e1c98ff5396dd2d1c95a0d8f08f85e51cf05b1ed85ea7b5bcf73c4ca5d301dd"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c910b1eeb3587b770b5a4c77904a7e5ad35824740762571a93fdef18175c0c39"
    sha256 cellar: :any,                 arm64_monterey: "814f89b6e1bfcf86c29eefef47ccc5077c8d38efd4626cccc029363097048328"
    sha256 cellar: :any,                 arm64_big_sur:  "e9a3123cc035debcdac3582b5aa868cf8ab2f64d10c2ddac6e41df4df0121d52"
    sha256 cellar: :any,                 ventura:        "cc3c9357bd9440f49aa61f7483fe31561a035e544416727ee785bcef94014022"
    sha256 cellar: :any,                 monterey:       "43b6e66bf25c5be9893862c174e4a1aaaf3928f38bc68c25d0177026d3923a4f"
    sha256 cellar: :any,                 big_sur:        "206b69b4456fabe2614dbf5c5ab2886530d2b238f18adb28545a9758fc9a4561"
    sha256 cellar: :any,                 catalina:       "bc28c6d58a3838fac59ab625ab26a917b3b0282ac54a8f37a95034efd0740007"
    sha256 cellar: :any,                 mojave:         "cbe02395698a24f9f835b7cba4128a308a15beefda6ad7e79cfd38d73823cdc2"
    sha256 cellar: :any,                 high_sierra:    "67666cd80446c78b49deac3b8f2589ccbd140f32b739b662556a6dc7bda7b453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a6745104a8b8035108f38a3f35ae90527790a02641cca54c29e99c962c74f16"
  end

  depends_on "libnet"

  def install
    # libnet 1.2 compatibility - it is API compatible with 1.1.
    # arp-sk's last update was in 2004.
    inreplace "configure", "1.1.", "1.2"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-libnet=#{Formula["libnet"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match "arp-sk version #{version}", shell_output("#{sbin}/arp-sk -V")
  end
end
