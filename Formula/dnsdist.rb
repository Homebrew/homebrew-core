class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.3.0.tar.bz2"
  sha256 "aa67cd4db8404a13ed4ed1097dd850203dab8a327372f72bb140df11ef7eba08"

  bottle do
    sha256 "7aacb96a39ca2fc3f8bf08ca62f2a2bd7bcff290f06cfb0517ba552e9bdf5cdb" => :high_sierra
    sha256 "bf56956092df94ba2ede745dff8ea37fb5059f252593cb4dc7c0699fe3b081ac" => :sierra
    sha256 "009d81af1fcec266485d5706bf9df16850346d5ac0285a75d695c12a3ef49869" => :el_capitan
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  # Remove for > 1.3.0
  # Boost 1.67 compatibility; backported by Jan Beich in FreeBSD
  # Upstream fix from 16 Mar 2018 "Logging: have a global g_log"
  # See https://github.com/PowerDNS/pdns/commit/e6a9dde524b57bb57f1d063ef195bb1e2667c5fc
  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/6fa3dca03cf2e321018d6894ddce6f7f33b64305/dns/dnsdist/files/patch-boost-1.67"
    sha256 "58f2e42ccd55e97429e3692aeeda6c9f24e4c4300bf384eaffc12ac3e8079dfb"
  end

  def install
    # error: unknown type name 'mach_port_t'
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    if MacOS.version == :high_sierra
      sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
      ENV["LIBEDIT_CFLAGS"] = "-I#{sdk}/usr/include -I#{sdk}/usr/include/editline"
      ENV["LIBEDIT_LIBS"] = "-L/usr/lib -ledit -lcurses"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-net-snmp",
                          "--sysconfdir=#{etc}/dnsdist"
    system "make", "install"
  end

  test do
    (testpath/"dnsdist.conf").write "setLocal('127.0.0.1')"
    output = shell_output("#{bin}/dnsdist -C dnsdist.conf --check-config 2>&1")
    assert_equal "Configuration 'dnsdist.conf' OK!", output.chomp
  end
end
