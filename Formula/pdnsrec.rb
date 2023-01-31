class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.8.2.tar.bz2"
  sha256 "4382d3e84f13401685772779dfede6cbc8157ecf6763fa7fdb1dd33ee3f79ac7"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "0fc50c2d1fd2c6541d9fb86e2fb3d26e113eab22f2c69e095838979ecdb33b10"
    sha256 arm64_monterey: "319a1fb7b75e3e49e5dab818b255425715d9df62f843d74c7d5963caf4c780ab"
    sha256 arm64_big_sur:  "805adf575a619e0d70949f1d1873d318fe215333e3e8929f7c779f51e61f7f23"
    sha256 ventura:        "06c33bbbbdbf28d69af9934aa047f0796be5001affa8674fee6352b32ed3f64f"
    sha256 monterey:       "596d22e45d7f5b0e0a2f13d3cee3c28f2b1ced86ec5a7cac02114e1ada904425"
    sha256 big_sur:        "b952c2562f5c135da75593c0c5a17d0bf259b1e71c8f9fed5c7823dccbb95bd6"
    sha256 x86_64_linux:   "505839e72f2da4fa2dbe5ffeafa7eabd625e0beda9ec246d5534ba4bb38472d2"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "MOADNSParser::init(bool, std::__1::basic_string_view<char, std::__1::char_traits<char> > const&)"
    EOS
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-libcrypto=#{Formula["openssl@3"].opt_prefix}
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
