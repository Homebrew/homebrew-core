class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.1.3.tar.bz2"
  sha256 "c133455f7abc1e44800603c134cdadf1968b802f77348555179087734c7da88b"

  bottle do
    sha256 "8cf7484b0cb02cc9d1222ca9e474cb3fcafe8bdcbd7720d69c9375dd9c9cd2a4" => :high_sierra
    sha256 "dffa06d1d83406770f09da3966937f3b0d68783b222d350143e0540c9e2d5e8b" => :sierra
    sha256 "74103d04843378c90a90eedcb20ab037db6f3f80df300d2e16676d2e9a4af68c" => :el_capitan
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
