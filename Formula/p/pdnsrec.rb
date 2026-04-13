class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.4.0.tar.xz"
  sha256 "2f69ef7586adc805bc4f503e15a34f0c6dcfbbfdab7d959ff132d8e2cdbf250a"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ae3ecbbca89611430786eebb3084d3c452822a2b05bb95b4fc3bed83cb65208c"
    sha256 arm64_sequoia: "5ccf64ca2616a357dc856b6581944ff1eb392c0045cc4e13942cca0d982361c5"
    sha256 arm64_sonoma:  "ea801397e4cdba92d931a4956c44ae8eb21276b21a9d69eaad32d1f3a81c777d"
    sha256 sonoma:        "2427e98f702dcf42c753468ffc781ce4a1cbfae8169c4b2589fd0780b9f55339"
    sha256 arm64_linux:   "93da768cab53319f0c9229f5af0f9ee2f46f6708d664599464e7cca61e36be63"
    sha256 x86_64_linux:  "9ba9b75a3088b180679edccc4623c7227f1f951f6006a2f62f37bbde83eb9339"
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
