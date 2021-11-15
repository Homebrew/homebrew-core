class NetSnmp < Formula
  desc "Implements SNMP v1, v2c, and v3, using IPv4 and IPv6"
  homepage "http://www.net-snmp.org/"
  url "https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.9.1/net-snmp-5.9.1.tar.gz"
  sha256 "eb7fd4a44de6cddbffd9a92a85ad1309e5c1054fb9d5a7dd93079c8953f48c3f"
  license "Net-SNMP"
  head "https://github.com/net-snmp/net-snmp.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/net-snmp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "d21afc167bfdcfb751d13cc5b7971f3f4348947c2a52133e97852c909d92011c"
    sha256 arm64_big_sur:  "78fa5061c6ba9240160cacfaa7b1c2f526d3a2dd8d3121ea4f6ba5bacced8a86"
    sha256 monterey:       "0c2d53594b23ca23a9f4f4d0e7a9511b9e84168cfbb2595a1d93455e52a9d1e7"
    sha256 big_sur:        "263ce5cfee921c1a75b0427e19cb15be78d6f65b2f2630d04ea4f5aac087f435"
    sha256 catalina:       "7eaea9810b5847062284f67e1ac83a8f96739a3d9dec0428237717467aeec312"
    sha256 mojave:         "8c57e53e0e45997e91c0071b9e7ee245d8610f935731b1ec6738b141274593eb"
    sha256 x86_64_linux:   "177521069687eb0366887e0fedb1ebfec14a28d3dd139830cb8eca0664bfdebe"
  end

  keg_only :provided_by_macos

  if Hardware::CPU.arm?
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"

  # Fix -flat_namespace being used on x86_64 Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # Workaround https://github.com/net-snmp/net-snmp/issues/226 in 5.9:
    inreplace "agent/mibgroup/mibII/icmp.h", "darwin10", "darwin"

    args = [
      "--disable-debugging",
      "--prefix=#{prefix}",
      "--enable-ipv6",
      "--with-defaults",
      "--with-persistent-directory=#{var}/db/net-snmp",
      "--with-logfile=#{var}/log/snmpd.log",
      "--with-mib-modules=host ucd-snmp/diskio",
      "--without-rpm",
      "--without-kmem-usage",
      "--disable-embedded-perl",
      "--without-perl-modules",
      "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
    ]

    system "autoreconf", "-fvi" if Hardware::CPU.arm?
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
