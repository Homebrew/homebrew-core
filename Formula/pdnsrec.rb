class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.1.4.tar.bz2"
  sha256 "b19f4353bea3fe54a581a4e7ace101637f8474f5ebfe925e2d3ff4910b71b550"

  bottle do
    sha256 "324b5650c13c396603b3a3146ec1d34cae0ee6f6581e6a03d4c4cf3f4279e98c" => :mojave
    sha256 "0bec1537a23c906110eb882451e7f6a23c8cd1f4efe4f0b8d231441aee29712c" => :high_sierra
    sha256 "13d7deb2f2f06d40842f60f1f641bbd0c00006bbc69673e93a0885563f9cb562" => :sierra
    sha256 "6c2a044482066cbdf24c8fcf7a828f5035d4757ba678c7640db526f4d6126230" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gcc" if DevelopmentTools.clang_build_version <= 600
  depends_on "lua"
  depends_on "openssl"

  fails_with :clang do
    build 600
    cause "incomplete C++11 support"
  end

  needs :cxx11

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
