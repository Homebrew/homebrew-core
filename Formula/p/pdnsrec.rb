class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.4.1.tar.xz"
  sha256 "93f23ee93fb0d3a9fd48817265631ece4758b8001af726c358ee3afb6645b63a"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ed830ebc6f863e7043bc1e9a7d3d6362e20b240aac5f049cf78da58b08a24747"
    sha256 arm64_sequoia: "2a5b3fc12a1e126a062e9aec3ebce7cd71af6862263b506dffaa14fd3a0bad6c"
    sha256 arm64_sonoma:  "43808ae02beccf606c09418f4008a22cfb3a7a6c5802dc2dea68231e8dc3dcb0"
    sha256 sonoma:        "79e8552c110d00fd92cef1304c5bfd3e713f12e9aeeddfeb2dfc6fa8492e7ab7"
    sha256 arm64_linux:   "86e773f487811845fd6bcb06bb2efa805a9eeef34e1e7ef8f6fb42866074082e"
    sha256 x86_64_linux:  "2dc91ce375e4c2b61f1f6df7e9857865c849c8e178a09491273db06ab8c3ff07"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"

  uses_from_macos "python" => :build
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
    args = %W[
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-libcrypto=#{Formula["openssl@3"].opt_prefix}
      --with-lua
      --without-net-snmp
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/pdns_recursor --version 2>&1")
    assert_match "PowerDNS Recursor #{version}", output
  end
end
