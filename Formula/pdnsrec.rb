class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.1.0.tar.bz2"
  sha256 "880b9d4cc57e2b11cae5bff9b20571fb3466f4385c010d06764296fef44f60a3"
  revision 1

  bottle do
    sha256 "11bdc4f5fefc37ec4aa50b0689262034a63a9ad26663116fcbbc1d43475bd029" => :high_sierra
    sha256 "63f61ff6e6066090b6341133c6acf256fc139117710181394ff21daad3b2c80c" => :sierra
    sha256 "01c68fe54ea7c000a0356bb862475d7dfd431ea13ba795b59a1e2aace82a5158" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl"
  depends_on "lua"
  depends_on "gcc" if DevelopmentTools.clang_build_version <= 600

  needs :cxx11

  fails_with :clang do
    build 600
    cause "incomplete C++11 support"
  end

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-libcrypto=#{Formula["openssl"].opt_prefix}
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
