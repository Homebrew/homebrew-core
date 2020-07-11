class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.4.0.tar.bz2"
  sha256 "a336fa2c3eb381c2464d9d9790014fd6d4505029ed2c1b73ee1dc9115a2f1dc0"
  revision 2

  bottle do
    sha256 "602c852e16dff8212099643fc37627d727178db0d133cc86d090e9ab0d218fda" => :catalina
    sha256 "0d7838982a1c01e4951117cd8f34432b4eb707e425ebe10631a1b68905e67f85" => :mojave
    sha256 "6a7bd408e30e104559bd989faab8c3bdde347164b72ec146ae6a025337e9ebfa" => :high_sierra
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
