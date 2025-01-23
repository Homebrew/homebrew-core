class NetSnmp < Formula
  desc "Implements SNMP v1, v2c, and v3, using IPv4 and IPv6"
  homepage "http://www.net-snmp.org/"
  url "https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.9.4/net-snmp-5.9.4.tar.gz"
  sha256 "8b4de01391e74e3c7014beb43961a2d6d6fa03acc34280b9585f4930745b0544"
  license all_of: ["MIT-CMU", "MIT", "BSD-3-Clause"]
  head "https://github.com/net-snmp/net-snmp.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/net-snmp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia:  "fdeaf56a79dfe93f7ed48765a26f6b34f030f1a0d96950410c7c4a3100eb0e7f"
    sha256 arm64_sonoma:   "9d0ea2f793065eab2cb7c858d5926bb9ec40dfd0460a31c4d9f09932ae1c2455"
    sha256 arm64_ventura:  "8d1f5f1b9c27087c08b7fb17c97445d925c7c0afa77e4939979778ca9fc39fa4"
    sha256 arm64_monterey: "0ee61805fb803dc4126a163c1f41438fbae869158cab3c5f9fb4db626ace6059"
    sha256 arm64_big_sur:  "08d71e1fd013508a956360a8c1ee0806974b21334e06daa519c91fc58e5b1cf4"
    sha256 sonoma:         "520f34569542954e98b71e04ec30a470994550f983969d476ba7a3e229e9795e"
    sha256 ventura:        "72c6a3af4f5dc6649fdf8ace41e27c917d88bfb4f25b6a468cc072944ae42cc1"
    sha256 monterey:       "25f84e57f018ce8d5c4f60ecdb28bf93a53f53fb7c3fe2d2ade1053013ba8993"
    sha256 big_sur:        "6eb8407f90572a45ff98d040761b9857998638d9a739bd21c06e1420412009ee"
    sha256 x86_64_linux:   "909269505e442c956639f60e3b0cd1dbdc1e7723eb96b291e9fdba7781d533f4"
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
