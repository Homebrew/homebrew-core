class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.0.6.tar.bz2"
  sha256 "d90885d2abb7ddfe9741cd8fbf5b9ba6902296c77b2f51248779066591ef3f32"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "1fccd0195bcb5aeeba858c94bec27c0e8cbfb87760819e50c0e4034940649da2"
    sha256 arm64_ventura:  "9790eb96fef3fbd398dceab9a5b6311f43af7bc9f3cab3ca52509d23baf68a81"
    sha256 arm64_monterey: "ed65d6aa2f92d4889ea619b83535d10e8d73b40df1d22ba5cea65a742c790f7b"
    sha256 sonoma:         "d73b9c52e4b715a27de7ae0381915e2ccfb3eb53af2ca67d4d67295db31ddcae"
    sha256 ventura:        "9d60a28f9b3aee1b7a4bbccb15f1e2ba4d7c0acf245584499a1040961c2cbed4"
    sha256 monterey:       "74ede7257de9ff776ba65f6f2a16ac9f3e27d293480732377229c6993517e44d"
    sha256 x86_64_linux:   "a22a16c9cb0c7c88fa3d200985c1e5113772e4e9f8ceb109eeb16256d16c201f"
  end

  depends_on "pkg-config" => :build
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
