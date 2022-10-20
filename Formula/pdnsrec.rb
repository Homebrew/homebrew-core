class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.7.3.tar.bz2"
  sha256 "206d766cc8f0189f79d69af64d8d937ecc61a4d13e8ea6594d78fe30e61405f2"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "545cabf2fab59bfa31074c0f54ca648bf04017c486dc7d00695e9d6aae62086a"
    sha256 arm64_big_sur:  "edbc699abe012511916a3e42e70f383b4e708e8d347d406703c40f27100ab111"
    sha256 monterey:       "16cc3ed4ce2cad714c9f104aace79f0d04349b2404889f68bc8c8eb06a3f68a5"
    sha256 big_sur:        "4e39d5f924c94ea3b9369f880b8fa189def7bf94334bd6eec55a6cdd7e52205c"
    sha256 catalina:       "01ed74e76a319d6c2f6ab080cc7fb9f1d293faf845ca05ce8cf39880a6a43c21"
    sha256 x86_64_linux:   "15c9a10856b58447b1afc70e860fb08d8fa990ed67e1b42ba0764e8b94294553"
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
