class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.8.4.tar.bz2"
  sha256 "f0a63fd08e03da82fa20d333ea5179d1b9259f4264546cf4995286677d9458c7"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "f01a95b2928bebde86e685c48aa2ca99ca41914b5552802d5adcc259165dd2a6"
    sha256 arm64_monterey: "14d4a3d3588f5c79244747e62899e427a2a867b1e885b0817befb01723f92dc8"
    sha256 arm64_big_sur:  "38a09d0cbf186062d8a0b4d4b9087af12523e2141a9877ca71adafeef99465bd"
    sha256 ventura:        "4c1f6193c2ea51441768f73426a51b68c9ad5957f41d7e7b35ee08207e6b90e5"
    sha256 monterey:       "6d3c2b0954436bbddc600224fe51b1d758b15ab7763ef14e76b2b2cdc0f02bda"
    sha256 big_sur:        "de9df8f4c7a6feceab1ba313ce6807723a8412845119b8af4823e2c870a6cf80"
    sha256 x86_64_linux:   "b1432fad4208813b3ee8f94279719ccddb2350898abe4220daf41baa613379e6"
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
