class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.0.7.tar.bz2"
  sha256 "966d1654c32c72bd0cc9b301ae5b723a34e36f3c02e62c73a7643260122f94e7"

  bottle do
    sha256 "545c4e165dabc5ab3fb46a568b25307b5fc63a3c5cee97657053af5cfa6c72bf" => :high_sierra
    sha256 "cc9312578fb77bed4d92725ccec1a49d40a5113743117aff240d7a7021ca015c" => :sierra
    sha256 "bd074b480630fc4dab01fe3886c2430dc3617aec6e34d6e68cc8cec84ffaebe7" => :el_capitan
    sha256 "efe5c4b834cb36612741b353c4705fda3510f42f8ee09265b4077373e7a05669" => :yosemite
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
