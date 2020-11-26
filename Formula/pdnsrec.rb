class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.4.1.tar.bz2"
  sha256 "f97fa34635d42c68acee5d4da9db0e5ff619fd49e62acace7b4bdb7ee3675698"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "95d9be202a5f58a8b18a6620d02bc3ad9e3f088c66c2e55bf97c44a41eadac4c" => :big_sur
    sha256 "795fb2e62f31fb0c13516cffccd35d4d7bc60f61b3e22e34801073a550cca88f" => :catalina
    sha256 "237f535f843c8dec4330b59787b47c6b2c43329c8229781d6e9e9f12dca210c4" => :mojave
    sha256 "65313fdb9d7482410b9ed3ee768fda93b64b9eca449b8d1620fcc59bb2ff9e73" => :high_sierra
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
