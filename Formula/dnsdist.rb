class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.3.2.tar.bz2"
  sha256 "0be7704e5a418a8ed6908fc110ecfb9bc23f270b5af8a5525f1fa934ef0e6bc4"

  bottle do
    sha256 "7aacb96a39ca2fc3f8bf08ca62f2a2bd7bcff290f06cfb0517ba552e9bdf5cdb" => :high_sierra
    sha256 "bf56956092df94ba2ede745dff8ea37fb5059f252593cb4dc7c0699fe3b081ac" => :sierra
    sha256 "009d81af1fcec266485d5706bf9df16850346d5ac0285a75d695c12a3ef49869" => :el_capitan
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

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
