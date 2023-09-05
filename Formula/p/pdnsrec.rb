class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.9.1.tar.bz2"
  sha256 "0a1edc13e8f2bd661f39e316387d941e22de6a03b8a7a2fc662fdf8b942ea2be"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "ea27bb4982e910b0ef61008de12ba63830300545ea72d24706f70ef06cd4d5ed"
    sha256 arm64_monterey: "25a7a9b9dd08d3492196a4c704ad68f6dfb429348d464b86247313623ea5ba51"
    sha256 arm64_big_sur:  "95c8fc8a4c86e0c811b91f68018825f8ac0cd8cedff9a127af61a0f3c7c0f3d2"
    sha256 ventura:        "db92f6d5fd727d7ef01442a99a94432509204d1fcd2990ec6ee85c76fcb297d6"
    sha256 monterey:       "6c1d46010c229ce5a67d2692d0a040b4bc1638435f7ff30700991df67438f7a5"
    sha256 big_sur:        "6f9cb98fc1556afab3bcba149b82d72c4117e3427c53ba08ae8bdb18a207daf6"
    sha256 x86_64_linux:   "b9bc3d2c7819e4f8cfee7362c4303f823bbbe7edd3eeff8484f17c2d70af71bc"
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
