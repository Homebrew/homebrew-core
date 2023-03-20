class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.8.3.tar.bz2"
  sha256 "37b91a5458c54411f4e38e2d1263ecf41e751e43c5fd66e813100d9978f02505"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "dfa5ad0e339b527180f245c56e5fa00cec89fa0b1c17dca88cb8357662da3771"
    sha256 arm64_monterey: "ad7d2a805be8a056981cf53e8557c6cf78f215c2e335e02094311a271d051be4"
    sha256 arm64_big_sur:  "82ab1bb1f9f364e12abde3a62717c76a2bc83eed28460085a93f8b5d51c67ffe"
    sha256 ventura:        "33b07f76933e062cc988d81871552e91a5e12560773eccc11353eb70dc83c35d"
    sha256 monterey:       "48258a0fc796e1409da99b569f51ad62f908bfa28fcf2bf42d5d3e81a6d524f8"
    sha256 big_sur:        "552155b03b5f461371843c12f657548f853b8e7b05c432dc21021afa5cbfcd12"
    sha256 x86_64_linux:   "f9d76cd2603b92b1d581c656b7207ce6eb78460ef0c881b209a26c870b595d86"
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
