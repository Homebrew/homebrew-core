class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.3.0.tar.bz2"
  sha256 "2bc130f287dfdb32e03d0b38a4ac24baf1117f96eca9b407611c847fa08a628f"

  bottle do
    sha256 "57a69e90b1047a447012bf889ee0719a0a860b37a38e7af038bd90b1c0ee16a8" => :catalina
    sha256 "61e2ffaf35d65fe6f35c2c70e23a4acc82807a2c898315f2476acff0ef17e3eb" => :mojave
    sha256 "0f8010db27a1a0c1f1cb036a860689a9c9e348ef83b64c1a296b228adf79fbd2" => :high_sierra
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
