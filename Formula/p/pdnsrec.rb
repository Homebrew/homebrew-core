class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.1.2.tar.bz2"
  sha256 "b3a37ebb20285ab9acbbb0e1370e623bb398ed3087f0e678f23ffa3b0063983d"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "a1af5a80bbcf3aa120b90ec0d375939a4b2f869def8ded6b5daec4ee55da434d"
    sha256 arm64_sonoma:  "2bc68e0fa028d5b34c89df967fe7cbbe7f55d8a91b3a2f9160639c35046f8e40"
    sha256 arm64_ventura: "5932d71b150cb46183bb20a081003fe44b68f6d5a70e42c20326212a883c9e3c"
    sha256 sonoma:        "67e8cf1f617ddf19ec598b760e80c37f589438f05f30952a0c691b05eea5ed62"
    sha256 ventura:       "76dca78bedf780a7bfe16ce53ba5418b2664d1ead1dee13663bc9a5012a17c85"
    sha256 x86_64_linux:  "e5c9f7c571a9c47ab19c5b819d79fbcf7da8c8da57594ebf8d3e4d4f9e504f7a"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"

  uses_from_macos "curl"

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
