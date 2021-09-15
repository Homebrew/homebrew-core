class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.5.5.tar.bz2"
  sha256 "a836a39b99fcc21873e4ba3a60aa9915a33fac7b44922696e9a257f551fe05fb"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "6d91a9a10c37e9957d9d54a9b1c7dfd053a590582078dedabe0c1b2c5583fbff"
    sha256 big_sur:       "2e5c07a26540b304ae52a2ed4569a09a0f6f9641f93b3cdcc4ce81c14423936c"
    sha256 catalina:      "0c3355b03b41fb4ad9d76bdb6d0f87f90ebe52c0f20fbf0721904e9393a33cca"
    sha256 mojave:        "30bf6621caa349c712e84b8211877f55785c356dbdce558c390b6fdf19bf3ad7"
    sha256 x86_64_linux:  "21af0d49fd6b901131459386156de07159a58110d3b37690fdc1fe55c43ae045"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@1.1"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
  end

  on_linux do
    depends_on "gcc"
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
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-libcrypto=#{Formula["openssl@1.1"].opt_prefix}
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
