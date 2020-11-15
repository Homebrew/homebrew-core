class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.5.1.tar.bz2"
  sha256 "cae759729a87703f4d09b0ed4227cb224aaaa252fa92f2432fd7116f560afbf1"
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "f22642d83c7b76914c05a2607c660ac8a60158ff4ac6287114fcb3ff86a4328a" => :big_sur
    sha256 "c21a37f8b202fe9c3257d3b3bc13058d5c55b2cb86dd2ca42af541bb27de9160" => :catalina
    sha256 "18f713b5f63b18ac0aa5fa40ea0cbe088b209a5ed7c0c035cb6f8dedad2b891b" => :mojave
    sha256 "5894b2dd3badaa2e8c7e4b3fe691870f0477d3b7c8461465cae6c6891d3fdc40" => :high_sierra
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "cdb"
  depends_on "fstrm"
  depends_on "h2o"
  depends_on "libsodium"
  depends_on "luajit"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "re2"

  uses_from_macos "libedit"

  def install
    # error: unknown type name 'mach_port_t'
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-net-snmp",
                          "--enable-dns-over-tls",
                          "--enable-dns-over-https",
                          "--enable-dnscrypt",
                          "--with-re2",
                          "--sysconfdir=#{etc}/dnsdist"
    system "make", "install"
  end

  test do
    (testpath/"dnsdist.conf").write "setLocal('127.0.0.1')"
    output = shell_output("#{bin}/dnsdist -C dnsdist.conf --check-config 2>&1")
    assert_equal "Configuration 'dnsdist.conf' OK!", output.chomp
  end
end
