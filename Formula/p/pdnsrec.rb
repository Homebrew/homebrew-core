class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.2.2.tar.bz2"
  sha256 "f9c95274231ee3c5c94197f6d05011d55abf06b2937535ba8e78e24ea4fbbd6e"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "ec4f9b4fbeb9186a0e51c04a4c16f0612099b7802c4f6df8f16f781632e76f4b"
    sha256 arm64_sonoma:  "994ef2ddd9953410aaf90364d230b22db7dd7782e5e59a9768dd3ad2d3e898f3"
    sha256 arm64_ventura: "d778487a526936f8019d50f9b886c4f3190ef6d6658081bc9b33aba936142830"
    sha256 sonoma:        "a14a17bd672dfd8b42e4a1f541878e5f845766320b3e0416bfb01370a0bb275c"
    sha256 ventura:       "683941889d4db54c3c439843f85e64350baa0ca1e7de4ec02db6747f68cf49d2"
    sha256 arm64_linux:   "dc61b56ac97253a4443536bc03338e64d2a8b7502a6aad0557a27fb27d1a52bb"
    sha256 x86_64_linux:  "61f0693bd6243500e92375fefba61c2ee6cba7d85b79ed026a7f6ef414d40487"
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
