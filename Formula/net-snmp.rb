class NetSnmp < Formula
  desc "Implements SNMP v1, v2c, and v3, using IPv4 and IPv6"
  homepage "http://www.net-snmp.org/"
  url "https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.9.3/net-snmp-5.9.3.tar.gz"
  sha256 "2097f29b7e1bf3f1300b4bae52fa2308d0bb8d5d3998dbe02f9462a413a2ef0a"
  license "Net-SNMP"
  revision 1
  head "https://github.com/net-snmp/net-snmp.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/net-snmp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "973c5a70d31b4893335403e3700d99ec20cbb9fa0a1c6f5c63272d992f4a28c3"
    sha256 arm64_monterey: "eccc19bb8d4e9c47be0ed1e9f522c0f41447ee539b31da65d1044fe434f6f688"
    sha256 arm64_big_sur:  "7aad43ff95d69fef55d44ffe774847f5f3d9af3056af9db701e818db55e2df49"
    sha256 ventura:        "53d3a7d7b5dc726ebb3c5ba03f2194ebe82f0591921eb76691f6879b2fca86ad"
    sha256 monterey:       "d2d9f97a49fd0fd01d31b7506b4161e2a42ceffd4da1bea6bf4f7da385c6d3f0"
    sha256 big_sur:        "13c40ba686fe06c20eb5440e2e228b9048d079c1757e06dca0a3dde3641e845b"
    sha256 x86_64_linux:   "97480084603146cf9618a75fd5f13dc4a3a9194880ece8b7acc80d0a9fcfa91c"
  end

  keg_only :provided_by_macos

  depends_on "openssl@3"

  on_arm do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Fix -flat_namespace being used on x86_64 Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
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
      "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
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
