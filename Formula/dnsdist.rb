class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.5.0.tar.bz2"
  sha256 "2c07c4ef0c497f5223909ff181fe3ba7c6016962a2855cffe26b7f3609f27b58"
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "966e52196b218954cb252457453a653a0b0d6fc3bc96633c5bff789670f5f7bd" => :catalina
    sha256 "81133ff0d602c33f22835012446e8c9e38c00c2b38dd6f634bbe8cf5f3a1a61a" => :mojave
    sha256 "a6d4f91fb0fc868d795d219fbe89ad549fb72785dcae09fd1c15de1adab24c9c" => :high_sierra
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
