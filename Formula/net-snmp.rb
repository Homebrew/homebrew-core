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
    rebuild 1
    sha256 "4519ee0aa3a4ebdcb4235466861a13b41ff19363a2b83fce26ab507cdc40a015" => :big_sur
    sha256 "97ca904418f6fc7488478cec55106ce51987eb139fea9f90b38afa4240c4683b" => :catalina
    sha256 "ffac347f7d928bdc233355f324cff14a0751315661ef480d121362085b56f8d3" => :mojave
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
