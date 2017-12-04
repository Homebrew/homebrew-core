class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.1.0.tar.bz2"
  sha256 "880b9d4cc57e2b11cae5bff9b20571fb3466f4385c010d06764296fef44f60a3"

  bottle do
    sha256 "09f11d4b0f1b0c13ad5b34b1c30577640a72873dfe7643d25a85c648f1093f7d" => :high_sierra
    sha256 "caea7cad55d4ccc38560a3b7aeee083c403ed21e66da498d713ba681b97e1efe" => :sierra
    sha256 "3fbc2a3e03594bfd9b3157a8da73afe50ce02b36b24d3e6a983ca58e641301bc" => :el_capitan
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
