class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.9.0.tar.bz2"
  sha256 "d36f162843e367646a661a785ca0becde9b68552855bf40532aebafa103966f3"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "5ad054dc50027559219e41b7cfc2a4fd6cfc82da2ca915f65b437e3720a14a20"
    sha256 arm64_monterey: "20471457b019a13d55c07f2e8cd523eb374b0907eb2bc22f210ae30d9010ba1c"
    sha256 arm64_big_sur:  "e4f356003408714ff1a983c93167813c6f4600f1f8309de51f33f3c3ab4f85d6"
    sha256 ventura:        "9486e9851890a4271ee9297ed19f586a8208b9c9b7421ceb4c52aa204231ab17"
    sha256 monterey:       "7267220ee7a3dccc38731e948a1090042cca8f0811d5bdf907b50bc19bbb95e7"
    sha256 big_sur:        "b058511f221c257992273a37c3e42bafa896860c3235bed3e2492f36c49c1f0d"
    sha256 x86_64_linux:   "4399be3015eab46ca17c7e67b50d537635d93b5753b7ab8de8ee1c0abcd3a601"
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
