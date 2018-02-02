class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.1.1.tar.bz2"
  sha256 "8feb03c7141997775cb52c131579e8e34c9896ea8bb77276328f5f6cc4e1396b"

  bottle do
    sha256 "acf3ac20e35b04e046d21f99f74e8301a14f16e8740ac0ab140d2979a5eb6d09" => :high_sierra
    sha256 "ca5fca7f5c1f2ac202508bc09c11ceb34928e6f02363723f50c1da8ad985e6a6" => :sierra
    sha256 "19c92e4a6b850eb8852640da9f10e5f71dbf272d22b17c1e78ad9dbe538c088a" => :el_capitan
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
