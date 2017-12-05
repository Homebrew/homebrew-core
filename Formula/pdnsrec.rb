class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.1.0.tar.bz2"
  sha256 "880b9d4cc57e2b11cae5bff9b20571fb3466f4385c010d06764296fef44f60a3"

  bottle do
    sha256 "fe331413c2c6672d096dd2ed7a79f75cfaeabe9b9428a59b7071ae650580a5ce" => :high_sierra
    sha256 "7553826ce0f365c707f03f4cdb96bdba06837b5936cd55afcd200a65c6b18f2e" => :sierra
    sha256 "575e7cf7ee21d3528734fbd4e71f922f129117a7f5a0691ada9906d08f26af1f" => :el_capitan
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
