class NetSnmp < Formula
  desc "Implements SNMP v1, v2c, and v3, using IPv4 and IPv6"
  homepage "http://www.net-snmp.org/"
  url "https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.8/net-snmp-5.8.tar.gz"
  sha256 "b2fc3500840ebe532734c4786b0da4ef0a5f67e51ef4c86b3345d697e4976adf"
  revision 1

  bottle do
    sha256 "efd1bcbd0e99fc29571de33c64fd1494db705a114778800d8181a27424a24421" => :mojave
    sha256 "f5774ae4c5cc7f5a7fe5eb9eaa60f35842af5f6c2c184444428cc2e412f040fb" => :high_sierra
    sha256 "1b1ea4f4456b6fc36c501398852b2e9979791387f38993129382b75782176f97" => :sierra
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

  def install
    # https://sourceforge.net/p/net-snmp/bugs/2504/
    # I suspect upstream will fix this in the first post-Mojave release but
    # if it's not fixed in that release this should be reported upstream.
    (buildpath/"include/net-snmp/system/darwin18.h").write <<~EOS
      #include <net-snmp/system/darwin17.h>
    EOS
    (buildpath/"include/net-snmp/system/darwin19.h").write <<~EOS
      #include <net-snmp/system/darwin17.h>
    EOS

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
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

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
