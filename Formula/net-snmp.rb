class NetSnmp < Formula
  desc "Implements SNMP v1, v2c, and v3, using IPv4 and IPv6"
  homepage "http://www.net-snmp.org/"
  url "https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.9.3/net-snmp-5.9.3.tar.gz"
  sha256 "2097f29b7e1bf3f1300b4bae52fa2308d0bb8d5d3998dbe02f9462a413a2ef0a"
  license "Net-SNMP"
  head "https://github.com/net-snmp/net-snmp.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/net-snmp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "74d5403c022fe3d3dd01c276331e3d97209dea5813d6f203c389df54c7df6d5d"
    sha256 arm64_monterey: "634fb231f5cc587aa3a327e190f9f43333c34742fbe2d003742a0b627bcfde1a"
    sha256 arm64_big_sur:  "3a143759145e8d8adc231c73f006b9e434c2f706d62d1904b27eee925cd93ceb"
    sha256 ventura:        "a017848519388f8851c43458ac418dd0149ba6de760d50f5b496690a7b5e304c"
    sha256 monterey:       "c3bc6964e8232d21ccf46f16a4e0b35f1474cbe6676a5ebc27b7caf89737513a"
    sha256 big_sur:        "9e90ad8567f8bab19f76243cbabe2c39fb36c2473e2d5ea5ce4d0708f0b09933"
    sha256 catalina:       "80436ed0c97eb7fac29c905cdfd831bda8e6265c964006b3024cd57a728b5dc8"
    sha256 x86_64_linux:   "61f84c8fe4ecbc75c018359a8dff265638598efbf4dbf4d22fc5dea859908be0"
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

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
