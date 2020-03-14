class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.3.0.tar.bz2"
  sha256 "2bc130f287dfdb32e03d0b38a4ac24baf1117f96eca9b407611c847fa08a628f"

  bottle do
    sha256 "a688ecadacf25de7649f2d7466993bf14c427b61714710109ede701fd2db703d" => :catalina
    sha256 "8c206a5b2d444f4cca0729984b2cc310ac00bbd766a99ccaaacb868738f38af2" => :mojave
    sha256 "c00ff5ecd8b495097e320daa9751ca4893554ff62d169f5d971b08405e59d4b1" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gcc" if DevelopmentTools.clang_build_version == 600
  depends_on "lua"
  depends_on "openssl@1.1"

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
