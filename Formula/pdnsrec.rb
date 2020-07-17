class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.3.3.tar.bz2"
  sha256 "0bbc481d10806233579712a1e4d5f5ee27ca9860e10aa6e1ec317f032bea1508"
  license "GPL-2.0"

  bottle do
    sha256 "e10f8080dc0217d7b070d0fb2b55484834dce4a6816d192a4300997233424851" => :catalina
    sha256 "16ff5c044d1c7c412f5ec0542e9aff7cf5ea72c9f79809ce4b82d21004b0ed9d" => :mojave
    sha256 "c844e730c0615a742e7b83c1ff0579149dddef844e8d1552eae080924414d691" => :high_sierra
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
