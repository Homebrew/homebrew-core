class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.3.3.tar.xz"
  sha256 "ebeeb454bdf977a7f3947f17f3a4b2a17a37a673db1feb0f2f156b67b93a0329"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0665a1ecf9569d2711f74f72c60a7870c710ec07e93ca5314bbd3bee4b5e78ff"
    sha256 arm64_sequoia: "a9383ab23a9e05b3bc02d8591d06db1ef28c0883b6d3e47acd8b9417670ba4de"
    sha256 arm64_sonoma:  "1aa7663e8101b7b66620a369a005d3c6d611b47a9dad2406fa44914f5f50df75"
    sha256 sonoma:        "9cb995943fba1c6b6d33af04b3e0134b012b959acf13052eb767f8559cb7afef"
    sha256 arm64_linux:   "4a4d24f555fdc1da466dc19a3603e2ac247d18fd062694c925f83afcf63ee13b"
    sha256 x86_64_linux:  "693d128c119a00d792e60dbf3217314e8c2956b9f868ba500a5eda752e78b115"
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
