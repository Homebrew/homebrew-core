class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.1.3.tar.bz2"
  sha256 "c133455f7abc1e44800603c134cdadf1968b802f77348555179087734c7da88b"

  bottle do
    sha256 "5efee3e6ea8fde8c92baa0f2d400d3044c3032bc4dd1cac7d4d7c5d808d8e419" => :high_sierra
    sha256 "bb55dff8a5cd5151144bfb7c112d4e4b4c8843193b844e620eaa1408246d81f8" => :sierra
    sha256 "4404cbb99cd7a2b3fbd7b7c78a2d32462be5cad1b5cfe95c35b2b1a57e1febfe" => :el_capitan
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
