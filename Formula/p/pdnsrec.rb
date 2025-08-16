class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.2.5.tar.bz2"
  sha256 "a8a657a7abd6e9d237cdd26753f7dcf5ccd5b8c48ac8120b08d2b8d57a1d856a"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "4cfbe3c32ba0779876976d59aa18da7a16ed40513ae80bce6f041f74305b27bd"
    sha256 arm64_sonoma:  "80c59cb26588e4d21235857f96ec33365a4c532f948d4b3f2b8e53d16c7618f4"
    sha256 arm64_ventura: "5187ef9b4118569767849996a7593d5f30b7a9fb81b9ab688e13e1a60fd44482"
    sha256 sonoma:        "e2309884d2bb05dece92c45e620195436ebf9a89dfd0ea202574de1fe271de5a"
    sha256 ventura:       "6fd6e19ee04049595fd8a80a34a03ce8bef6152e9e996ced4f43a304a7b1542e"
    sha256 arm64_linux:   "fadc665e2bc29abb2354b72c0ce884ddea1265af7d935e8a540a07fc35d0030c"
    sha256 x86_64_linux:  "ba858b3a82395bbc87668f478bc866bfd90cd2e095eb66a6668ec3ba925c7c3a"
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
    # Workaround for Boost 1.89.0 until fixed upstream.
    # Issue ref: https://github.com/PowerDNS/pdns/issues/15972
    ENV["boost_cv_lib_system"] = "yes"

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
