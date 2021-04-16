class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.4.3.tar.bz2"
  sha256 "f8411258100cc310c75710d7f4d59b5eb4797f437f71dc466ed97a83f1babe05"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "48090a25f0c900d4f194ab2e12b8cff257c2c28ee48ba1a0be3cfef6613d5488"
    sha256 big_sur:       "5a70aeb0c0d0fd57d3529744b7c5a0bdeaecfb1897dd07cc0ba83a6fb883a089"
    sha256 catalina:      "b1653e702eee140a2bd6bd0ff463a9fec7b05fc998d87c4c5bf76b46b4e8a0bb"
    sha256 mojave:        "8656a83c7405cfeec550aae38a45ec31fd5b82ce3794394bc403da4c6cd7acad"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
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
