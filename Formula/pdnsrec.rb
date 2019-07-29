class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.1.14.tar.bz2"
  sha256 "7fceb8fa3bea693aad49d137c801bb3ecc15525cc5a7dc84380321546e87bf14"

  bottle do
    sha256 "fa7d5b14ace151a80a6d1d145e2765c0dec8b747df495b683059c96fac3c5165" => :mojave
    sha256 "29d655ef980aab518b454c445ab6a93b2a0def36943c3b3b494e47600726b581" => :high_sierra
    sha256 "b5ee0c66af508879f4bf8869a45c2110e21a0bd2307de9652e6dad84ee0cefd4" => :sierra
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
