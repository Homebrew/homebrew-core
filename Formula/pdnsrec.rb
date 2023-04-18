class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.8.4.tar.bz2"
  sha256 "f0a63fd08e03da82fa20d333ea5179d1b9259f4264546cf4995286677d9458c7"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "83ac581bebe3dd940b448ad9ff427fe38b35347fc1d492d4dc2ac0e5c904696a"
    sha256 arm64_monterey: "0440ccaeade0b296fcff4bda24fa779cf969e71113cfad667ea2dab14cf1cad4"
    sha256 arm64_big_sur:  "a2a59d5646cefc032bdafc669e1f68bbe972b58990692db75e35b714477b58f7"
    sha256 ventura:        "2f6c751e036de1a38f66e3c419e9096af6f7fa3281951b550abdb1755906bf66"
    sha256 monterey:       "3504b58bede9b459e6a4862411ef1fbf4afaf7b4bdd214822e2e389c600f12e5"
    sha256 big_sur:        "0bb336bf8c995d5d24fe92b101b1ebd3aaf20bc289136b9d8626b0c1b1af0c8c"
    sha256 x86_64_linux:   "bed10cfe6901a37abb9f478b1216ba7e94f37b327a70171c16f72a4e3a564282"
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
