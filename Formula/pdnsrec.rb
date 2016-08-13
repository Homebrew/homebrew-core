class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.0.1.tar.bz2"
  sha256 "472db541307c8ca83a846d260ecfc854fd8e879c1bb2ce5683a8df5d21e860b0"
  revision 1

  bottle do
    sha256 "6d1db92d6832f010a0e4e4f466a2fa3003320acbbffaf4bf3345f74f2ea706a3" => :el_capitan
    sha256 "b4cb635ee48914b7e59e643c17bcc23a23e6c5ca74c1e76da9a3489dd11fc525" => :yosemite
    sha256 "48cae0fd08da1919154a6b867906a836ccc82626939402690b120ebe3f7cfa87" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl"
  depends_on "lua"
  depends_on "gcc" if MacOS.version <= :mavericks

  needs :cxx11

  fails_with :clang do
    build 600
    cause "incomplete C++11 support"
  end

  # boost 1.61.0 compat
  # upstream commit "fix type"; remove for > 4.0.1
  patch :p2 do
    url "https://github.com/PowerDNS/pdns/commit/33f13fde.patch"
    sha256 "f7944b9fd573619bdeb20bc211b3eb5fd4f129cb0e691ece686d213ebf6e5393"
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
