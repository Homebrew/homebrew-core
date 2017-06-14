class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.0.5.tar.bz2"
  sha256 "ba43ce4280b3a06afebe58c5d63680f51dd525c63d1de7f3b229b380e6b1b7af"

  bottle do
    sha256 "2cdc2cca4313b14afa5f744a2f2fa9bf9a6d56a32a9d13b5fb04cbe976f430d3" => :sierra
    sha256 "e529af26e330e54cb114e8adde9f458d83470da4f371bedac01a5c2dc724a339" => :el_capitan
    sha256 "149d602439855b0b8a09854d746ab4f31d340db26179530e73309e77ac3878ef" => :yosemite
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
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --with-lua
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/pdns_recursor --version 2>&1")
    assert_match "PowerDNS Recursor #{version}", output
  end
end
