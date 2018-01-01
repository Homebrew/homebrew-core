class NetSnmp < Formula
  desc "Implements SNMP v1, v2c, and v3, using IPv4 and IPv6"
  homepage "http://www.net-snmp.org/"
  url "https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.7.3/net-snmp-5.7.3.tar.gz"
  sha256 "12ef89613c7707dc96d13335f153c1921efc9d61d3708ef09f3fc4a7014fb4f0"

  bottle do
    rebuild 3
    sha256 "810f52fc141c942236b6cc2439f577528d406c337c0dd3f331e02396078ff529" => :high_sierra
    sha256 "02542e6f3fd23d1833059c86563c961fc24a230a013e0887d3a2d50b42eb2887" => :sierra
    sha256 "e3209635fdbb10b65e4c405c94e0ac05010be95bde728875fca399209ddee114" => :el_capitan
    sha256 "1c11e18b727f83f3a736df297d492952867d7de129608b584555edf7c0d7aec6" => :yosemite
    sha256 "ae16cd409d8bfac5bfc80135ad3d9ba1439b95c963e3e9ded30c4dc379c3ac33" => :mavericks
  end

  keg_only :provided_by_osx

  depends_on "openssl"
  depends_on "python" => :optional

  def install
    args = %W[
      --disable-debugging
      --prefix=#{prefix}
      --enable-ipv6
      --with-defaults
      --with-persistent-directory=#{var}/db/net-snmp
      --with-logfile=#{var}/log/snmpd.log
      --with-mib-modules=host\ ucd-snmp/diskio
      --without-rpm
      --without-kmem-usage
      --disable-embedded-perl
      --without-perl-modules
      --with-openssl=#{Formula["openssl"].opt_prefix}
    ]

    if build.with? "python"
      args << "--with-python-modules"
      ENV["PYTHONPROG"] = which("python")
    end

    # https://sourceforge.net/p/net-snmp/bugs/2504/
    ln_s "darwin13.h", "include/net-snmp/system/darwin14.h"
    ln_s "darwin13.h", "include/net-snmp/system/darwin15.h"
    ln_s "darwin13.h", "include/net-snmp/system/darwin16.h"
    ln_s "darwin13.h", "include/net-snmp/system/darwin17.h"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    (var/"db/net-snmp").mkpath
    (var/"log").mkpath
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snmpwalk -V 2>&1")
  end
end
