class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.3.3.tar.xz"
  sha256 "ebeeb454bdf977a7f3947f17f3a4b2a17a37a673db1feb0f2f156b67b93a0329"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  revision 2

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "1534a602b6049e1eef96537a7b89a4c11b7d92f970743e2dbe3ba702a15d2a27"
    sha256 arm64_sequoia: "1766f6cd036ba261f9ca85998d1ee853a00c7404b0eaf9e522a623f7785bdec4"
    sha256 arm64_sonoma:  "8804c6d6fc74a40bfcabfedc342d55b815cc60d3f3359859c2b93d389095ee4f"
    sha256 sonoma:        "ef7f9a838392ccb325bcb1e98e3f9b096615dca41868b4b02d2d189e34c86d70"
    sha256 arm64_linux:   "af33dc52edf6916afa7e2744c9e8acdf15288896499930c344f27a696901ce2f"
    sha256 x86_64_linux:  "ac1cc3801c1aae4461621c900832839fc2ff146d2267f451279119ed72ca1b77"
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
