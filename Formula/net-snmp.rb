class NetSnmp < Formula
  desc "Implements SNMP v1, v2c, and v3, using IPv4 and IPv6"
  homepage "http://www.net-snmp.org/"
  url "https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.9/net-snmp-5.9.tar.gz"
  sha256 "04303a66f85d6d8b16d3cc53bde50428877c82ab524e17591dfceaeb94df6071"
  license "Net-SNMP"

  livecheck do
    url :stable
    regex(%r{url=.*?/net-snmp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "46837a0296f9a9cb434371d7377800da0e0e06a09ef07a0d70bd79d8bbe3bfb2" => :catalina
    sha256 "57dc4d78d02ec37a30d822b40aca17afc187de70c15d87c62bd660c5cc17d211" => :mojave
    sha256 "8285c2dfee4c083c7ea0f5c99964aaa68c5cc26e4c223405727ec9fc85d636db" => :high_sierra
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
