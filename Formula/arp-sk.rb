class ArpSk < Formula
  desc "ARP traffic generation tool"
  homepage "https://web.archive.org/web/20180223202629/sid.rstack.org/arp-sk/"
  url "https://web.archive.org/web/20180223202629/sid.rstack.org/arp-sk/files/arp-sk-0.0.16.tgz"
  mirror "https://pkg.freebsd.org/ports-distfiles/arp-sk-0.0.16.tgz"
  sha256 "6e1c98ff5396dd2d1c95a0d8f08f85e51cf05b1ed85ea7b5bcf73c4ca5d301dd"
  revision 1

  bottle do
    cellar :any
    sha256 "bc28c6d58a3838fac59ab625ab26a917b3b0282ac54a8f37a95034efd0740007" => :catalina
    sha256 "cbe02395698a24f9f835b7cba4128a308a15beefda6ad7e79cfd38d73823cdc2" => :mojave
    sha256 "67666cd80446c78b49deac3b8f2589ccbd140f32b739b662556a6dc7bda7b453" => :high_sierra
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
