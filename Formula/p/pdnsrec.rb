class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.3.5.tar.xz"
  sha256 "74497ae620167d857ce2d5702bd14018e5f4c848e878f29cef51581a74b0d05e"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "8fa853ea2e8ad5948e52be74e8e3033287e02295fd6e454967b0d056cb8701ef"
    sha256 arm64_sequoia: "d6f4936df8e64d3d112bc11289c8c2cea63a7dee498a8017305eb136ef7b3385"
    sha256 arm64_sonoma:  "ebd5c5ff9a56e75a16b57a5c2ca81b0902ce743643f8c849918c6771e6556959"
    sha256 sonoma:        "a21892997f88f0cdcc14b166a2fc6ff3ed0240dce47e49c39606db9996afb72c"
    sha256 arm64_linux:   "cb2b8de285450af96b151199eaf518124ba0263627eaf66ca1c7e2e1f035b050"
    sha256 x86_64_linux:  "bfb139181396d6a74cfbe10a1a317b29a96b9ab6d21e26cd4a6f35f06bd44331"
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
