class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.3.4.tar.xz"
  sha256 "fb50a8587f4b3d57f88dcacc226a64c5154992b0dafd20f5bb034355e3624524"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "6631c361d339afc59f1811136182c5f21f2ed440f3f78d166fb751cd93bf8653"
    sha256 arm64_sequoia: "31000e5582fc27e16ac20fabe1a341563c47798d42d2fea34e1c2d3a20c5de9b"
    sha256 arm64_sonoma:  "ce16c87e61cee682f882231a8fb7143cb7b8db03b68034ca9f59533e5eafa8f2"
    sha256 sonoma:        "f450f3a97b3b807251db90ec7681cc7ae3e6fc9b58e53b85711123cf2cfc6cef"
    sha256 arm64_linux:   "0021534dbd4b508f647d97c1f4c500341f2d299748b5ddd59ebe0277445dda17"
    sha256 x86_64_linux:  "de209a4ec3e03e513367bc167355e1629e507f7e73032b35c9af67c615a2faae"
  end

  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
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
