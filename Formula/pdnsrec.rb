class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.1.12.tar.bz2"
  sha256 "e41c0a9825915084794edd86e31bb9bde558a5efa8e178c168b82546fecdb0c8"

  bottle do
    sha256 "5c4cc0a99b3219b428871573b70b1bbea73009020c1fb77258f7fb4d45aecf6f" => :mojave
    sha256 "15b220d44b8f2649718b83101515bd1652e000efd32a8a97541cca4b3a659008" => :high_sierra
    sha256 "815f1334d369a621e301d4305a30226f49a6a6c85499b8d9bf245464547fc173" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gcc" if DevelopmentTools.clang_build_version == 600
  depends_on "lua"
  depends_on "openssl"

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
