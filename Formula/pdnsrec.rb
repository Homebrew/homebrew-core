class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.0.5.tar.bz2"
  sha256 "ba43ce4280b3a06afebe58c5d63680f51dd525c63d1de7f3b229b380e6b1b7af"

  bottle do
    sha256 "03762bdb4660c3801b3707d8380b1329404c60bf3f1aee30de8df869deed91be" => :sierra
    sha256 "8dc88ce84b649c2d32d7a939ca32d15c302792dc901a05989d0b98e515a28d0e" => :el_capitan
    sha256 "47dfb88865e8b74a08a23331ec5cd55e9c6979701f58fe568563688e51226c7e" => :yosemite
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
