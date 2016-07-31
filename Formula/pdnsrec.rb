class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.0.1.tar.bz2"
  sha256 "472db541307c8ca83a846d260ecfc854fd8e879c1bb2ce5683a8df5d21e860b0"

  bottle do
    sha256 "31428673a49cfd7d9499e98154daefc493da5e4457adb3ff58ea5f60fdd08ba2" => :el_capitan
    sha256 "e08235e2eac088be0bd6a6ec69536874173a0ff02a2707d1a63e19132bc30f1a" => :yosemite
    sha256 "32433ecf6ab52d6c4f2c4f1bcb9f7d56102766fa23d316a9354932d86ed9f255" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl"
  depends_on "lua"

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
