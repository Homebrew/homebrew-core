class NetSnmp < Formula
  desc "Implements SNMP v1, v2c, and v3, using IPv4 and IPv6"
  homepage "http://www.net-snmp.org/"
  url "https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.9/net-snmp-5.9.tar.gz"
  sha256 "04303a66f85d6d8b16d3cc53bde50428877c82ab524e17591dfceaeb94df6071"
  license "Net-SNMP"
  head "https://github.com/net-snmp/net-snmp.git"

  livecheck do
    url :stable
    regex(%r{url=.*?/net-snmp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 2
    sha256 "f76220e8e7bffba146b3886d46d61dca81e947d2d77937e8c756b1f6f242526d" => :big_sur
    sha256 "546fe0a8e74e43d8e8ba6d5526a73096aa7e4e92b9f66d910b6146206753e556" => :arm64_big_sur
    sha256 "04210e391fad9e36b9fe9945e4a8b6436263e64aaf24ac0069202c6581c8d624" => :catalina
    sha256 "1ac45c38fa251f876c70073ef1757c0a3b7659fb8f2ce7f5ec41af2febb1cac9" => :mojave
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

  # Fix "make install" bug with 5.9
  patch do
    url "https://github.com/net-snmp/net-snmp/commit/52d4a465dcd92db004c34c1ad6a86fe36726e61b.patch?full_index=1"
    sha256 "669185758aa3a4815f4bbbe533795c4b6969c0c80c573f8c8abfa86911c57492"
  end

  # Clean up some Xcode 12 issues with ./configure
  patch do
    url "https://github.com/net-snmp/net-snmp/commit/a7c8c26c48c954a19bca5fdc6ba285396610d7aa.patch?full_index=1"
    sha256 "8ccc46a3c15d145e5034c0749f3c0e7bd11eca451809ae7f2312dab459e07cec"
  end

  # Apple Silicon support
  # https://github.com/net-snmp/net-snmp/issues/228
  if Hardware::CPU.arm?
    patch do
      url "https://github.com/net-snmp/net-snmp/commit/bcc654e7.patch?full_index=1"
      sha256 "b5e35ef021e1962bd2fbf675f05eb43cc75bd7d417687d736a4c4b508a9eed47"
    end
  end

  def install
    # Workaround https://github.com/net-snmp/net-snmp/issues/226 in 5.9:
    inreplace "agent/mibgroup/mibII/icmp.h", "darwin10", "darwin"

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
