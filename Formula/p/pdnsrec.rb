class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.0.4.tar.bz2"
  sha256 "d52aab108a0ad9e8be1de2179a693bb85e995c6a4d958a50702dcf79eec8ef28"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ce346f4f1d641d8f447d8c9117fc2bd20bb596f50dee383368cf4d162d822f2a"
    sha256 arm64_ventura:  "6925297503e8c1a9a204e4d2b3a2c4e970d97711a5676edd6ad3e42970864c84"
    sha256 arm64_monterey: "54cd469160288840ff7d0ed718f9c803db65a950dd70bcafaea92a2c72f9fe5c"
    sha256 sonoma:         "90462ac1e935cd649d337eb29190f603967363c29ed1aec1527180f45d7243ef"
    sha256 ventura:        "a47f3d303d8ed6506a684d12f085dcfb8b008b230943d602c1e224f74b8c417d"
    sha256 monterey:       "76181795fa3d48f0cb1fee8052544ca7fb22e06aee35b07c736a547a031db741"
    sha256 x86_64_linux:   "e570809afd6f86c60d04f929465a0ceb2a869cecdb554e64ac1fbcf2c9ba0d2b"
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
