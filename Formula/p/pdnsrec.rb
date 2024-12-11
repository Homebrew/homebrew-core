class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.1.3.tar.bz2"
  sha256 "c34ee31f522d93997e04ab2ed0fb58de6569c13ed2a2cb0d371cef49a585356a"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "d39d99f50a9faa4930c53cccd4523f96f714534d8b451da7aee4901067e5852a"
    sha256 arm64_sonoma:  "205cbb72a025f112394579fa2c0505fff082de938b4661bf394747c8e6eeaa82"
    sha256 arm64_ventura: "46c1519c1e233fcaa04ad06b26cbe9b8f5fd1baf04aff741ed7922a23fc7c3b6"
    sha256 sonoma:        "d69ca7830e338ab817471a60bad915d60dc39e8cdaa83d3fb7ca7be4a8837a4a"
    sha256 ventura:       "9e402489725b2789f6ed2f5ab235ed7b0eddc0bd7d7749bf0b317b84d26d5eeb"
    sha256 x86_64_linux:  "147788759dc5124c955f4889a8c047534c2ccf8991383c7b600c82add87f5262"
  end

  depends_on "pkgconf" => :build
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
    cause <<~EOS
      Undefined symbols for architecture x86_64:
        "MOADNSParser::init(bool, std::__1::basic_string_view<char, std::__1::char_traits<char> > const&)"
    EOS
  end

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
