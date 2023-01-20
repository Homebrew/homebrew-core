class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.8.1.tar.bz2"
  sha256 "d7b03447009257e512f01fcc46cbdb9c859b672a1c9b23faf382e870765b0f0d"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "39ce25470b06f6680a7d291fad6f78c5416da346223a751342e7d3395c8251d0"
    sha256 arm64_monterey: "7bb4a703ec0c55a5965bca1c0c7ca8192c544223df4519f7f77a13bc0fd7b5fc"
    sha256 arm64_big_sur:  "22ea9497eaa34fa6ffc8c51e4247e207c11b66653c3d3b543f984ccd978d1183"
    sha256 ventura:        "dd4db28863cd4b37935e038f4011cb252cc7f14c04452a6f18fca5bb6dfd633b"
    sha256 monterey:       "ffbb83b3336a792881a1248a7ef770beb3e7060aa51f883e8640b2aae38a7cdb"
    sha256 big_sur:        "eeab11f2b84b1bb4ad7b83541ddedcdcd868309d1e6409ba3f686140d419e3bc"
    sha256 x86_64_linux:   "ab6e0347ce3ccc462792cd5e03219f11722fcf77c30bdbfeebaf441eab0862fa"
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
