class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.2.0.tar.bz2"
  sha256 "f03c72c1816fdcc645cc539d8c16721d2ec294feac9b5179e78c3db311b7c2c2"
  revision 1

  bottle do
    sha256 "71057462df37d088432c13d44b4dc8f4dbdd5a8217e2fefd04043c1cdf5c5ffd" => :mojave
    sha256 "71510209042aab52e8a23c70f449553c730203bdfd09b111dde599bf9e7d6b70" => :high_sierra
    sha256 "047f17b12423d7570a3db99a8f12bb980bfc60c95b924a2ba919aa193910aa98" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gcc" if DevelopmentTools.clang_build_version == 600
  depends_on "lua"
  depends_on "openssl@1.1"

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
      --with-libcrypto=#{Formula["openssl@1.1"].opt_prefix}
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
