class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.4.1.tar.bz2"
  sha256 "f97fa34635d42c68acee5d4da9db0e5ff619fd49e62acace7b4bdb7ee3675698"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "cc0c48157bb2e39fcd9fe29ca33e35e580b4bd9046c20e7e1357fdc4154dbeca" => :big_sur
    sha256 "c8c1e5a526b6588cd95d02e3bf6c7c14dd9f8ea4ff3ec0601855c5df2d0ccf68" => :catalina
    sha256 "4c389f453d543f51becd243a370a239bcd228187e9f0f5bebc45e94de078d749" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gcc" if DevelopmentTools.clang_build_version == 600
  depends_on "lua"
  depends_on "openssl@1.1"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-libcrypto=#{Formula["openssl@1.1"].opt_prefix}
      --with-lua
      --without-net-snmp
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/pdns_recursor --version 2>&1")
    assert_match "PowerDNS Recursor #{version}", output
  end
end
