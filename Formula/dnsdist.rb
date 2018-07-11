class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.3.2.tar.bz2"
  sha256 "0be7704e5a418a8ed6908fc110ecfb9bc23f270b5af8a5525f1fa934ef0e6bc4"

  bottle do
    sha256 "62320372f4328e35695e03165f4565a2a229ecbc6b9d4a9a8943fbe68a010ff9" => :high_sierra
    sha256 "8665f0e58905c19d1270b14914b9373ba286abbc4891307f91c67e7ab1327e53" => :sierra
    sha256 "02106300b645be33f32a0bd38dadabce717a5bea74a75dcd353854d3b629580c" => :el_capitan
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
